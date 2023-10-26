**Test Name**: my_test

- **I/O Engine**: libaio
- **Read/Write Type**: Random Read (randread)
- **Block Size**: 4KB
- **Direct I/O**: Yes (direct=1)
- **Test File Size**: 1GB
- **Concurrent Jobs**: 1
- **File Name**: test1

**Test Results**:

- IOPS (I/O Operations Per Second): 187
- Bandwidth (BW): 751KiB/s (769kB/s)
- Test Duration: 1395988 milliseconds (approximately 23 minutes)
- Data Read: 1024MiB (about 1GB)

**Latency Information**:

- Minimum Latency: 4 microseconds
- Maximum Latency: 1730.8 milliseconds
- Average Latency: 5319.36 microseconds
- Latency Distribution Percentiles:
  - 1.00th: 55 microseconds
  - 5.00th: 644 microseconds
  - 10.00th: 750 microseconds
  - 50.00th: 1172 microseconds
  - 90.00th: 15664 microseconds
  - 99.00th: 67634 microseconds
  - 99.90th: 137364 microseconds

**Bandwidth (BW) Statistics**:

- Minimum Bandwidth: 16KiB/s
- Maximum Bandwidth: 4424KiB/s
- Average Bandwidth: 751.22KiB/s
- Bandwidth Standard Deviation: 278.67

**IOPS Statistics**:

- Minimum IOPS: 4
- Maximum IOPS: 1106
- Average IOPS: 187.77
- IOPS Standard Deviation: 69.68

**Latency Distribution**:

- 0.01% within 2 microseconds
- 0.66% within 50 microseconds
- 1.27% within 100 microseconds
- 26.85% within 1 millisecond
- 43.35% within 2 milliseconds
- 7.61% within 10 milliseconds
- 5.33% within 50 milliseconds
- 1.26% within 100 milliseconds
- 0.39% within 250 milliseconds
- 0.02% within 500 milliseconds
- 0.01% within 750 milliseconds
- 0.01% within 1 second
- 0.01% within 2 seconds

**CPU Usage**:

- User: 0.20%
- System: 0.48%

**I/O Depths**:

- Depth 1: 100.0%

**Submission and Completion Statistics**:

- Submit: 100.0%
- Complete: 100.0%

**Issued I/O Operations**:

- Total: 262144
- Read: 0
- Write: 0
- Short: 0
- Dropped: 0

**Disk Statistics (Read/Write)**:

- Read Operations: 261964
- Write Operations: 1655
- Merged Operations: 0/1146
- IO Wait Time: 1387300/24164
- In Queue: 25660
- Disk Utilization: 1.84%
