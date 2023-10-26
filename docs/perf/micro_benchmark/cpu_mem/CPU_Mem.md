## CPU and Memory

**installation**

```shell
sudo apt-get install stress-ng
```

**matrix multiple for CPU (60s)**

```shell
stress-ng --matrix 0 --timeout 60s --metrics-brief
```

> ubuntu@kata1:~$ stress-ng --matrix 0 --timeout 60s --metrics-brief
> stress-ng: info:  [18986] dispatching hogs: 4 matrix
> stress-ng: info:  [18986] successful run completed in 60.00s (1 min, 0.00 secs)
> stress-ng: info:  [18986] stressor       bogo ops real time  usr time  sys time   bogo ops/s   bogo ops/s
> stress-ng: info:  [18986]                           (secs)    (secs)    (secs)   (real time) (usr+sys time)
> stress-ng: info:  [18986] matrix          1350948     60.00    238.84      0.31     22515.79      5648.96

4 cores

- `stressor`: Type of test, here it is `matrix`.
- `bogo ops`: Number of operations completed during the test, which is `1350948` here. This is a relative performance measure, more for comparison than a representation of actual operations.
- `real time`: Actual time taken for the test, here it's `60.00` seconds.
- `usr time`: CPU time spent in user mode, here it is `238.84` seconds. This means all matrix computation processes combined spent around 239 seconds in user mode.
- `sys time`: CPU time spent in kernel mode, here it is `0.31` seconds.
- `bogo ops/s (real time)`: Operations per second based on the actual run time, here it is `22515.79`. It's a measure of how many operations can be completed per second in real time.
- `bogo ops/s (usr+sys time)`: Operations per second based on CPU time (user mode + kernel mode), here it is `5648.96`.
  

**memory bandwidth** 

```shell
stress-ng --stream 4 --timeout 60s --metrics-brief
```

> ubuntu@kata1:~$ stress-ng --stream 4 --timeout 60s --metrics-brief
> stress-ng: info:  [19127] dispatching hogs: 4 stream
> stress-ng: info:  [19128] stress-ng-stream: stressor loosely based on a variant of the STREAM benchmark code
> stress-ng: info:  [19128] stress-ng-stream: do NOT submit any of these results to the STREAM benchmark results
> stress-ng: info:  [19128] stress-ng-stream: Using CPU cache size of 16384K
> stress-ng: info:  [19128] stress-ng-stream: memory rate: 10455.21 MB/sec, 4182.08 Mflop/sec (instance 0)
> stress-ng: info:  [19129] stress-ng-stream: memory rate: 10390.62 MB/sec, 4156.25 Mflop/sec (instance 1)
> stress-ng: info:  [19130] stress-ng-stream: memory rate: 9508.33 MB/sec, 3803.33 Mflop/sec (instance 2)
> stress-ng: info:  [19131] stress-ng-stream: memory rate: 9189.77 MB/sec, 3675.91 Mflop/sec (instance 3)
> stress-ng: info:  [19127] successful run completed in 60.02s (1 min, 0.02 secs)
> stress-ng: info:  [19127] stressor       bogo ops real time  usr time  sys time   bogo ops/s   bogo ops/s
> stress-ng: info:  [19127]                           (secs)    (secs)    (secs)   (real time) (usr+sys time)
> stress-ng: info:  [19127] stream            14805     60.01    238.47      0.24       246.69        62.02

For memory bandwidth, we can check memory rate for these four instances, the higher the MB/sec value, the better the memory bandwidth performance.



**vmem allocator**

```shell
stress-ng --vm 2 --vm-bytes 256M --timeout 60s --metrics-brief
```

> stress-ng: info: [19199] dispatching hogs: 2 vm
> stress-ng: info: [19199] successful run completed in 60.01s (1 min, 0.01 secs)
> stress-ng: info: [19199] stressor bogo ops real time usr time sys time bogo ops/s bogo ops/s
> stress-ng: info: [19199] (secs) (secs) (secs) (real time) (usr+sys time)
> stress-ng: info: [19199] vm 1592200 60.00 117.92 1.82 26535.44 13297.14
