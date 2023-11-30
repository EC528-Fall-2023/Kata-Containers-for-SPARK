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