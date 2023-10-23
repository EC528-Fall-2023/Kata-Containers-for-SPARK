## Performance Research

To enhance security, Kata Containers launch lightweight VMs for isolation, which can lead to some performance issues.

An article introduces the detailed mechanism of the communication process.

https://medium.com/kata-containers/exploration-and-practice-of-performance-tuning-for-kata-containers-2-0-85055d29e8b5

1. **how to manage the containers across the virtual machine?**
   kata-agent

2. **How does the shim process outside the virtual machine communicate with the agent process inside the virtual machine?**
   virtio-sock
   
   advantage: Socket-based, No Need for Networking(doesn't require the setup and management of IP addresses, routes, or the networking protocol stack), Performance Optimization

3. **How can the image/rootfs outside the virtual machine be accessed by the container inside the virtual machine to support container creation and running?**
   The config can be passed to the agent in VM by gRPC calling through vsock.
   ![](/Users/dongyingzhe/Desktop/Screenshot%202023-10-20%20at%2001.16.09.png)

4. **How can the container image/rootfs be accessed by the agent in the VM?**
   
   
   - Shared-fs: mount the host directory into the virtual machine by shared-fs.
   
   - Block device passthrough: The image/rootfs block device based on device mapper on host is passed through to the VM by virtio-scsi or virtio-blk (with their corresponding backend).

---

A recent unmerged PR for performance improvement using dragonball's vsock fd passthrough

https://github.com/kata-containers/kata-containers/pull/7483

---

Why use Kata not just VM? 

> how the architecture of kata gives a speedup compared to VMs

Kata Community answer: 

> The only speedup that Kata brings compared to usual VMs is boot time - we go ahead and have a very small kernel and hit our minimal user space very fast.  If you're looking at performance IO, it really isn't any different. virtio-net is what it is, and is similar in "traditional VM" and kata.
> Beacuse for IO, that's the same old virtio path (or direct assign), and KVM handling.


