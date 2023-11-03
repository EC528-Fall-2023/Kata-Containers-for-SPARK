#!/bin/sh

# Variables for the server and output directory
SERVER="kata2"
OUTPUT_DIR="./iperf_results"
SERVER_OUTPUT="${OUTPUT_DIR}/iperf_server_output.txt"
TCP_OUTPUT="${OUTPUT_DIR}/iperf_tcp_test_output.txt"
UDP_OUTPUT="${OUTPUT_DIR}/iperf_udp_test_output.txt"

# Make sure the output directory exists
mkdir -p "${OUTPUT_DIR}"

# Start the iperf3 server and redirect its output to a file
echo "\nStarting iperf3 server..."
iperf3 -s > "${SERVER_OUTPUT}" 2>&1 &

# Sleep for a few seconds to ensure the server is fully up and running before the client connects
sleep 5

# Connect to the server via SSH and run iperf3 for TCP test
echo "\nStarting iperf3 TCP test for 10 seconds..."
ssh "${SERVER}" "iperf3 -c kata1 --time 10" > "${TCP_OUTPUT}" 2>&1
echo "\niperf3 TCP test completed!"

# Connect to the server via SSH and run iperf3 for UDP test
echo "\nStarting iperf3 UDP test for 10 seconds..."
ssh "${SERVER}" "iperf3 -c kata1 -u --time 10" > "${UDP_OUTPUT}" 2>&1
echo "\niperf3 UDP test completed!"

# Sleep for a bit longer than the duration of the iperf test to ensure it has time to complete
sleep 12

# Stop the iperf3 server process
echo "\nStopping iperf3 server..."
pkill -f "iperf3 -s"

echo "\nAll iperf3 tests completed successfully!"
