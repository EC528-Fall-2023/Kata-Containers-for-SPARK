#!/bin/sh

# CPU Test: Matrix multiple for CPU (60s)
echo "\nStarting CPU Matrix multiplication test for 60 seconds..."
stress-ng --matrix 0 --timeout 60s --metrics-brief
echo "\nCPU Matrix multiplication test completed!"

# Memory Bandwidth Test
echo "\nStarting Memory Bandwidth test..."
stress-ng --stream 4 --timeout 60s --metrics-brief
echo "\nMemory Bandwidth test completed!"

# VMEM Allocator Test
echo "\nStarting VMEM Allocator test..."
stress-ng --vm 2 --vm-bytes 256M --timeout 60s --metrics-brief
echo "\nVMEM Allocator test completed!"

echo "\nAll stress tests completed successfully!"
