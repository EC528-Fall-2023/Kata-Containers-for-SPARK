## Networking

**installation**

```shell
sudo apt update
sudo apt install iperf3
```

**server side - default listening on port 5201**

```shell
iperf3 -s
```

**client side**

```shell
iperf3 -c kata1
iperf3 -c kata1 -u
```

**TCP bandwidth**

> - - - - - - - - - - - - - - - - - - - - - - - - -
> 
> [ ID] Interval           Transfer     Bandwidth
> [  5]   0.00-10.04  sec  0.00 Bytes  0.00 bits/sec                  sender
> [  5]   0.00-10.04  sec  11.4 GBytes  9.79 Gbits/sec                  receiver

UDP bandwidth

> [ ID] Interval           Transfer     Bandwidth       Jitter    Lost/Total Datagrams
> [  4]   0.00-10.00  sec  1.25 MBytes  1.05 Mbits/sec  0.052 ms  0/159 (0%)  
> [  4] Sent 159 datagrams

TODO: maybe need another tool to get info about P95 latency
