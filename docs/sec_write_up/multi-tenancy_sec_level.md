# Multi-tenancy with Yarn + Spark: `runc` Containers vs. Kata Containers

## Context: Multi-tenancy in Yarn + Spark

Multi-tenancy refers to multiple users or teams running their Spark jobs on the same Yarn cluster. This environment brings challenges:

- Users might run untrusted or poorly written code.
- Data from one user must be isolated from others.
- Resources need to be fairly allocated.

## Threat Model in Multi-tenancy

### 1. Malicious Spark Job Execution

#### Context:
In multi-tenant systems, there's a possibility that a user might run a malicious Spark job, either intentionally or due to compromised data/code. This job could target vulnerabilities within the container or the underlying infrastructure.

#### `runc` Containers:

**Example**: 
Imagine an attacker is able to upload a Spark job with a payload designed to exploit a known `runc` vulnerability. Once the job is scheduled and running:

- The malicious Spark job runs within its Yarn container.
- The payload identifies the vulnerability and attempts to break out of the container.
- If successful, the attacker gains access to the host system, potentially affecting other jobs or the cluster itself.

#### Kata Containers:

**Example**:
Even if the same malicious Spark job is run:

- The job starts inside a Yarn container which is inside a lightweight VM due to Kata.
- If the payload attempts to break out of the container, it finds itself still confined within the VM.
- The host system and other jobs, running in separate VMs, remain unaffected.

---

### 2. Snooping on Other Jobs' Data

#### Context:
Data privacy is a concern in multi-tenant systems. Malicious or misconfigured jobs might attempt to snoop on data processed by other jobs running concurrently.

#### `runc` Containers:

**Example**: 
A user submits a Spark job designed to monitor memory or I/O operations. Given the shared kernel:

- The Spark job starts processing within its assigned Yarn container.
- Due to some kernel-level vulnerability or misconfiguration, the job begins to monitor memory areas outside its allocation.
- It potentially captures data processed by other Spark jobs, leading to data leakage.

#### Kata Containers:

**Example**:
For the same snooping Spark job:

- The job is constrained not just by the Yarn container but also by the VM boundary.
- Any attempt to monitor memory outside its allocation is thwarted by the VM's isolation mechanism.
- Other jobs' data remains secure.

---

### 3. Resource Hijacking

#### Context:
Fair resource allocation is crucial in multi-tenant systems. Malicious or buggy jobs might try to consume more resources than allocated, degrading performance for other users.

#### `runc` Containers:

**Example**: 
A Spark job is submitted which has a bug causing it to spawn an excessive number of threads:

- The job runs within its Yarn container and starts consuming resources.
- Due to the bug, it starts to strain the shared resources of the host system.
- Other Spark jobs, even if they are within their resource limits, begin to experience performance degradation.

#### Kata Containers:

**Example**:
For the same buggy Spark job:

- As it begins to consume excessive resources, it's contained within its VM's boundary.
- The VM guarantees resources up to its allocation limit. Beyond this, the buggy job might crash or slow down, but it doesn't affect other jobs running in separate VMs.

---

## Defense Mechanisms in Multi-tenancy

### Yarn's Own Isolation (`runc` Defense)

- **Purpose**: Yarn provisions containers for Spark jobs, ensuring they don't interfere with each other.
- **Effectiveness**: Effective against most interferences but can be bypassed with kernel or runtime vulnerabilities.

### VM-based Isolation (Kata Defense for Yarn + Spark)

- **Purpose**: Run each Yarn container inside its own VM.
- **Effectiveness**: Strong isolation that ensures even if a Spark job becomes malicious or is compromised, it remains contained within its VM.

---

## Which Is Better for Multi-tenancy?

### Data Privacy and Isolation

- **`runc` Containers**: Rely heavily on Yarn's ability to isolate each job's data.
- **Kata Containers**: Offer an additional VM layer, making data leakage across jobs even more difficult.

### Fair Resource Allocation

- **`runc` Containers**: Depend on Yarn's resource scheduling.
- **Kata Containers**: The VM guarantees the resources (CPU, memory) allocated to it, ensuring more precise resource boundaries.

### Handling Untrusted Code

- **`runc` Containers**: Riskier, as malicious code might exploit the shared kernel or runtime.
- **Kata Containers**: Safer, as the code is further isolated within a VM.

---

## Conclusion for Multi-tenancy in Yarn + Spark

When considering multi-tenancy in Yarn and Spark, Kata Containers offer a significant security enhancement. While `runc` containers provide a level of isolation, the added VM layer in Kata ensures stricter resource boundaries, enhanced data privacy, and a higher degree of isolation against untrusted or malicious code.

---

### References

- [Kata Containers and Kubernetes Multi-tenancy](https://katacontainers.io/)
- [Yarn Resource Management](https://hadoop.apache.org/docs/current/hadoop-yarn/hadoop-yarn-site/ResourceManagerHA.html)
- [Spark on Yarn](https://spark.apache.org/docs/latest/running-on-yarn.html)

