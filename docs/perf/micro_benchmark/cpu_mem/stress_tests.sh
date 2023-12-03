#!/bin/sh

# Ensure the output directory exists
OUTPUT_DIR="./stress_test_results"
mkdir -p ${OUTPUT_DIR}

# CPU Test: Matrix multiplication for CPU (60s)
CPU_OUTPUT="${OUTPUT_DIR}/cpu_test_output.txt"
echo "\nStarting CPU Matrix multiplication test for 60 seconds..."
stress-ng --matrix 0 --timeout 10s --metrics-brief > ${CPU_OUTPUT} 2>&1
echo "\nCPU Matrix multiplication test completed!"

# Memory Bandwidth Test
MEM_OUTPUT="${OUTPUT_DIR}/memory_test_output.txt"
echo "\nStarting Memory Bandwidth test..."
stress-ng --stream 4 --timeout 10s --metrics-brief > ${MEM_OUTPUT} 2>&1
echo "\nMemory Bandwidth test completed!"

# VMEM Allocator Test
VMEM_OUTPUT="${OUTPUT_DIR}/vmem_test_output.txt"
echo "\nStarting VMEM Allocator test..."
stress-ng --vm 2 --vm-bytes 256M --timeout 10s --metrics-brief > ${VMEM_OUTPUT} 2>&1
echo "\nVMEM Allocator test completed!"

echo "\nAll stress tests completed successfully!"
