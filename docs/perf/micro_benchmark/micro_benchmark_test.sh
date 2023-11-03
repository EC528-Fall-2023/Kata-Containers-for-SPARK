#!/bin/sh

# Define the directories where the scripts are located
STORAGE_DIR="./storage"
CPU_MEM_DIR="./cpu_mem"
NETWORK_DIR="./network"

# Run the fio_test.sh script
echo "Running storage performance test..."
sh "${STORAGE_DIR}/fio_test.sh"
echo "Storage test completed."

# Run the stress_tests.sh script
echo "Running CPU and memory stress tests..."
sh "${CPU_MEM_DIR}/stress_tests.sh"
echo "CPU and memory tests completed."

# Run the network_test.sh script
echo "Running network test..."
sh "${NETWORK_DIR}/network_test.sh"
echo "Network test completed."

echo "All tests have been completed."
