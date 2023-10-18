Certainly! Here's the table of specific parameters for disk performance testing using FIO without the "Custom Test" entry:

| Test Scenario                    | FIO Parameter Settings                                       | Explanation                                                  |
| -------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Random Read Test                 | `--rw=randread`<br>`--bs=4k`<br>`--direct=1`<br>`--size=1G`<br>`--numjobs=1`<br>`--filename=/path/to/testfile` | Simulates random read operations with a 4KB block size on a 1GB file. |
| Random Write Test                | `--rw=randwrite`<br>`--bs=4k`<br>`--direct=1`<br>`--size=1G`<br>`--numjobs=1`<br>`--filename=/path/to/testfile` | Simulates random write operations with a 4KB block size on a 1GB file. |
| Sequential Read Test             | `--rw=read`<br>`--bs=1M`<br>`--direct=1`<br>`--size=1G`<br>`--numjobs=1`<br>`--filename=/path/to/testfile` | Simulates sequential read operations with a 1MB block size on a 1GB file. |
| Sequential Write Test            | `--rw=write`<br>`--bs=1M`<br>`--direct=1`<br>`--size=1G`<br>`--numjobs=1`<br>`--filename=/path/to/testfile` | Simulates sequential write operations with a 1MB block size on a 1GB file. |
| Random Read Multi-Threaded Test  | `--rw=randread`<br>`--bs=4k`<br>`--direct=1`<br>`--size=1G`<br>`--numjobs=4`<br>`--filename=/path/to/testfile` | Simulates random read operations with four concurrent threads on a 1GB file. |
| Random Write Multi-Threaded Test | `--rw=randwrite`<br>`--bs=4k`<br>`--direct=1`<br>`--size=1G`<br>`--numjobs=4`<br>`--filename=/path/to/testfile` | Simulates random write operations with four concurrent threads on a 1GB file. |
| Mixed Read/Write Test            | `--rw=randrw`<br>`--rwmixread=70`<br>`--bs=4k`<br>`--direct=1`<br>`--size=1G`<br>`--numjobs=1`<br>`--filename=/path/to/testfile` | Simulates a mixed workload with 70% reads and 30% writes using a 4KB block size on a 1GB file. |

- **Random Read Test**: This test simulates random read operations with a 4KB block size on a 1GB file. It measures the performance of random read access patterns.

- **Random Write Test**: Similar to the random read test, this test focuses on random write operations with a 4KB block size on a 1GB file.

- **Sequential Read Test**: This test measures sequential read performance using a larger 1MB block size on a 1GB file, simulating scenarios like large file transfers.

- **Sequential Write Test**: Similar to the sequential read test, this test assesses sequential write performance with a 1MB block size.

- **Random Read Multi-Threaded Test**: This test introduces concurrency by simulating random read operations with four concurrent threads on a 1GB file.

- **Random Write Multi-Threaded Test**: Similar to the multi-threaded read test, this test focuses on random write operations with four concurrent threads.

- **Mixed Read/Write Test**: This test represents a mixed workload with 70% reads and 30% writes using a 4KB block size on a 1GB file. It's a common scenario in many applications.

