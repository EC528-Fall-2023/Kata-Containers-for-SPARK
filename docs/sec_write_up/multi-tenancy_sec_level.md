# Multi-tenancy with Yarn + Spark: `runc` Containers vs. Kata Containers

## Context: Multi-tenancy in Yarn + Spark

Multi-tenancy refers to multiple users or teams running their Spark jobs on the same Yarn cluster. This environment brings challenges:

- Users might run untrusted or poorly written code.
- Data from one user must be isolated from others.
- Resources need to be fairly allocated.

## Threat Model in Multi-tenancy

### Malicious Spark Job Execution

- **`runc` Containers**: A Spark job could potentially exploit vulnerabilities in the Yarn container, affecting other jobs or the host system.
- **Kata Containers**: Even if a malicious job breaks out of its container, it’s still contained within a VM.

### Snooping on Other Jobs' Data

- **`runc` Containers**: While Yarn does provide isolation, sharing the host's kernel might leave a small window for data leakage across containers.
- **Kata Containers**: The VM layer further ensures data separation between jobs.

### Resource Hijacking

- **`runc` Containers**: A malicious or buggy job might consume more than its fair share of resources.
- **Kata Containers**: The VM boundary ensures stricter adherence to allocated resources.

## Defense Mechanisms in Multi-tenancy

### Yarn's Own Isolation (`runc` Defense)

- **Purpose**: Yarn provisions containers for Spark jobs, ensuring they don't interfere with each other.
- **Effectiveness**: Effective against most interferences but can be bypassed with kernel or runtime vulnerabilities.

### VM-based Isolation (Kata Defense for Yarn + Spark)

- **Purpose**: Run each Yarn container inside its VM.
- **Effectiveness**: Strong isolation that ensures even if a Spark job becomes malicious or is compromised, it remains contained within its VM.

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

## Conclusion for Multi-tenancy in Yarn + Spark

When considering multi-tenancy in Yarn and Spark, Kata Containers offer a significant security enhancement. While `runc` containers provide a level of isolation, the added VM layer in Kata ensures stricter resource boundaries, enhanced data privacy, and a higher degree of isolation against untrusted or malicious code.

### References

- [Kata Containers and Kubernetes Multi-tenancy](https://katacontainers.io/)
- [Yarn Resource Management](https://hadoop.apache.org/docs/current/hadoop-yarn/hadoop-yarn-site/ResourceManagerHA.html)
- [Spark on Yarn](https://spark.apache.org/docs/latest/running-on-yarn.html)

---
