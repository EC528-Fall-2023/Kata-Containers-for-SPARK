# Random Write Test Results

| Random Write Test          | Performance Metrics                  |
|-----------------------------|--------------------------------------|
| **Throughput**              |                                      |
| - IOPS                      | 12.4k                               |
| - Bandwidth                 | 48.3MiB/s or 50.6MB/s               |
| **Average Latency**        | Approx. 77.38 microseconds           |
| **Latency Percentiles**    | 90% under 117 microseconds           |
| **Bandwidth Variability**  | Min: 31,872KiB/s, Max: 59,784KiB/s  |

# Random Write Test Results

| Random Write Test          | Performance Metrics                  |
|-----------------------------|--------------------------------------|
| **Throughput**              |                                      |
| - IOPS                      | 12.4k                               |
| - Bandwidth                 | 48.3MiB/s or 50.6MB/s               |
| **Average Latency**        | Approx. 77.38 microseconds           |
| **Latency Percentiles**    | 90% under 117 microseconds           |
| **Bandwidth Variability**  | Min: 31,872KiB/s, Max: 59,784KiB/s  |

# Sequential Read Test Results

| Sequential Read Test       | Performance Metrics                  |
|----------------------------|-------------------------------------|
| **Throughput**             |                                    |
| - IOPS                     | 92                                |
| - Bandwidth                | 92.3MiB/s or 96.8MB/s             |
| **Average Latency**       | Approx. 10.83 milliseconds         |
| **Latency Percentiles**   | 90% under 25 milliseconds          |
| **Bandwidth Variability** | Min: 40,960KiB/s, Max: 131,072KiB/s|

# Sequential Write Test Results

| Sequential Write Test      | Performance Metrics                 |
|----------------------------|-------------------------------------|
| **Throughput**             |                                    |
| - IOPS                     | 131                                |
| - Bandwidth                | 131MiB/s or 137MB/s                |
| **Average Latency**       | Approx. 7.59 milliseconds           |
| **Latency Percentiles**   | 90% under 34.87 milliseconds        |
| **Bandwidth Variability** | Min: 106,496KiB/s, Max: 163,840KiB/s|

# Random Read Multi-Threaded Test Results

| Data Point         | Job 1    | Job 2    | Job 3    | Job 4    | Average  |
|--------------------|----------|----------|----------|----------|----------|
| **IOPS**           | 488      | 409      | 375      | 581      | 463.25   |
| **BW (KiB/s)**     | 1954     | 1638     | 1500     | 2325     | 1854.25  |
| **clat avg (usec)**| 2040.14  | 2435.33  | 2659.52  | 1714.00  | 2212.25  |
| **lat avg (usec)** | 2041.56  | 2436.70  | 2660.93  | 1715.37  | 2213.64  |
| **cpu usr (%)**    | 0.45     | 0.30     | 0.32     | 0.32     | 0.3475   |
| **cpu sys (%)**    | 0.95     | 0.84     | 0.71     | 0.67     | 0.7925   |

## FIO Random Write Multi-Threaded Test Results

| Metric                    | Job 1  | Job 2  | Job 3  | Job 4          | Average  |
|---------------------------|--------|--------|--------|----------------|----------|
| Write IOPS                | 3458   | 3203   | 3087   | 3087           | 3208.75  |
| Write Bandwidth (MiB/s)   | 13.5   | 12.5   | 12.1   | 12.1           | 12.55    |
| Average Latency (usec)    | 285.99 | 308.83 | 320.59 | 320.76         | 309.04   |
| CPU User (%)              | 1.46   | 1.49   | 1.41   | 1.45           | ~1.45    |
| CPU System (%)            | 6.56   | 6.64   | 6.54   | 6.58           | ~6.58    |

# Mixed Read-Write Test Results

## Read

| Metric                     | Value                         |
|----------------------------|-------------------------------|
| **Throughput**             |                               |
| - IOPS                     | 461                           |
| - Bandwidth                | 1845KiB/s or 1890kB/s         |
| **Average Latency**        | Approx. 2105.24 microseconds  |
| **Latency Percentiles**    | 90% under 1598 microseconds   |
| **Bandwidth Variability**  | Min: 552 KiB/s, Max: 2896 KiB/s |

## Write

| Metric                     | Value                         |
|----------------------------|-------------------------------|
| **Throughput**             |                               |
| - IOPS                     | 196                           |
| - Bandwidth                | 787KiB/s or 806kB/s           |
| **Average Latency**        | Approx. 124.93 microseconds   |
| **Latency Percentiles**    | 90% under 172 microseconds    |
| **Bandwidth Variability**  | Min: 296 KiB/s, Max: 1360 KiB/s |

## Additional Information

- The read operations appear to have higher latencies than the write operations.
- Disk utilization was 3.01% during the test.

