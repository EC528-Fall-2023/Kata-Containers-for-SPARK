# Regular Container vs. Kata Container

## Regular Container (often using `runc`)

A regular container (like Docker containers using `runc`) is a lightweight, standalone, executable software package that contains everything needed to run a piece of software, including the code, runtime, system tools, system libraries, and settings. Containers are isolated from each other and from the host system.

### Advantages:

- **Lightweight**: Since they share the same OS kernel and isolate the application processes from each other, containers are lighter than virtual machines.
- **Fast**: Containers can start almost instantly.
- **Portable**: Can run consistently across different environments.

### Limitations:

- **Shared Kernel**: All containers on a host system share the same kernel. If the kernel is compromised, all containers can potentially be affected.

## Kata Container

Kata Containers is an open-source project that provides a container runtime using lightweight virtual machines (VMs). Instead of sharing the kernel with the host, each Kata Container runs inside its own lightweight VM.

### Advantages:

- **Isolation**: Uses hardware virtualization technology to provide an additional layer of isolation.
- **Compatible**: Kata Containers are OCI (Open Container Initiative) compatible, which means they can be managed in the same way as regular containers.
- **Security**: The VM-based approach means even if a malicious process breaks out of the container, it is still contained within a VM.

### Limitations:

- **Overhead**: Introduces a bit more overhead compared to regular containers due to the VM layer.
