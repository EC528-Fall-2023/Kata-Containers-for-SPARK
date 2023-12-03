### Entry
```shell
bash cpu_container.sh
```

### Different performance in CPU test (runc vs kata) analysis

runc

```textile
stress-ng: info:  [8] stressor       bogo ops real time  usr time  sys time   bogo ops/s     bogo ops/s
stress-ng: info:  [8]                           (secs)    (secs)    (secs)   (real time) (usr+sys time)
stress-ng: info:  [8] matrix          3294736     60.00   2398.65      0.01     54912.27        1373.57
```

kata

```textile
stress-ng: info:  [3] stressor       bogo ops real time  usr time  sys time   bogo ops/s     bogo ops/s
stress-ng: info:  [3]                           (secs)    (secs)    (secs)   (real time) (usr+sys time)
stress-ng: info:  [3] matrix           179884     60.00     59.97      0.00      2998.07        2999.57
```

`usr time` is much higher than `real time` in `runc`, while they are similar in `kata-runtime`

- **Differences in Multi-Core Parallel Processing**
  Under `runc`, containers run directly on the host's operating system, allowing multi-core CPUs to be fully utilized. Therefore, the user time of each core accumulates, leading to a total `usr time` significantly higher than `real time`.
  In `kata-runtime`, although multi-core processing is supported, each container runs inside a separate virtual machine. The resource management and scheduling in this environment might not be as efficiently optimized as `runc`. This can result in a less dramatic difference between `usr time` and `real time`.
  
- **Virtualization Overhead**
  `kata-runtime` employs virtual machines to provide stronger isolation, which introduces additional overhead. This overhead may limit the efficiency of parallel processing, making performance gains in multi-core environments less pronounced compared to `runc`.

### Different performance in Memory test (runc vs kata) analysis

runc

```textile
stress-ng: info:  [53] stress-ng-stream: memory rate: 7293.20 MB/sec, 2917.28 Mflop/sec (instance 3)
stress-ng: info:  [50] stress-ng-stream: memory rate: 7101.59 MB/sec, 2840.64 Mflop/sec (instance 0)
stress-ng: info:  [52] stress-ng-stream: memory rate: 7092.58 MB/sec, 2837.03 Mflop/sec (instance 2)
stress-ng: info:  [51] stress-ng-stream: memory rate: 7090.16 MB/sec, 2836.06 Mflop/sec (instance 1)
```

kata

```textile
stress-ng: info:  [8] stress-ng-stream: memory rate: 1696.57 MB/sec, 678.63 Mflop/sec (instance 2)
stress-ng: info:  [9] stress-ng-stream: memory rate: 1709.98 MB/sec, 683.99 Mflop/sec (instance 3)
stress-ng: info:  [6] stress-ng-stream: memory rate: 1709.28 MB/sec, 683.71 Mflop/sec (instance 0)
stress-ng: info:  [7] stress-ng-stream: memory rate: 1709.03 MB/sec, 683.61 Mflop/sec (instance 1)
```

- **Resource Allocation and Management**
  In the virtualized environment of `kata-runtime`, memory resource allocation and management might be more constrained. Virtual machines may not access and manage memory as efficiently as containers running directly on physical hardware.
  
- **Memory Access Patterns**
  `runc` containers can directly benefit from the host machine's memory access optimizations, such as hugepages. This can significantly improve memory access efficiency. In `kata-runtime`, due to the additional virtualization layer, these optimizations might not be available or as effective.

![CPU_MEM Comparison](./CPU%20and%20Memory.png)
