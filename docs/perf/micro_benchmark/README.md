## Micro Benchmarking

### Overview

This section outlines our micro benchmarking strategy for assessing key hardware components: storage, network, CPU, and memory. The objective is to isolate and evaluate the performance of each component to identify potential areas for improvement.

### Testing Methodology

1. **Storage Performance Test** (`fio_test.sh`):
   - Implements `fio` for various disk I/O tests including random and sequential read/write operations, in both single-threaded and multi-threaded modes.
   - Results are compiled in `fio_results.csv` for analysis.

2. **Network Performance Test** (`network_test.sh`):
   - Uses `iperf3` to test network performance, encompassing both TCP and UDP protocols, between two nodes (`kata1` and `kata2`).
   - Test outputs are stored in the `iperf_results` directory.

3. **CPU and Memory Stress Tests** (`stress_tests.sh`):
   - Runs CPU-intensive tasks (matrix multiplication) and memory benchmarks using `stress-ng`.
   - Test results are saved in the `stress_test_results` directory.
   - Additional tests are conducted using Docker containers to evaluate performance under different runtime conditions.

### Execution Procedure

- Execute each script from its designated directory: `./storage/fio_test.sh`, `./network/network_test.sh`, and `./cpu_mem/stress_tests.sh`.
- Ensure all necessary packages and Docker images are installed and configured beforehand.
- Monitor the system for stability and consistency throughout the testing process.

### Reporting and Analysis

- Each test's results are stored in drawn in graphs and visualized.

### Conclusion

Our micro benchmarking efforts are designed to thoroughly assess the impact of each system component on overall performance. We can say that kata makes slightly reduce to those components which can be ignored.