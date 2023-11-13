#!/bin/bash

# Install required packages
sudo apt update
sudo apt install -y fio jq

# Define file path for disk I/O tests within the user's home directory
TESTFILE="$HOME/fio_testfile"
TESTDIR=$(dirname ${TESTFILE})
if [ ! -d "${TESTDIR}" ]; then
    echo "Directory ${TESTDIR} does not exist. Creating it..."
    mkdir -p "${TESTDIR}"
fi

# Run disk I/O tests with fio
echo "Starting Disk I/O tests..."

# Define an array of test names to iterate through
declare -a tests=("random_read_test" "random_write_test" "sequential_read_test" "sequential_write_test" "random_read_multi_threaded_test" "random_write_multi_threaded_test" "mixed_read_write_test")

# Initialize CSV file with header
echo "Test Name,Read IOPS,Write IOPS" > fio_results.csv

# Function to translate test names to fio rw parameters
translate_to_rw() {
    case "$1" in
        random_read*) echo "randread" ;;
        random_write*) echo "randwrite" ;;
        sequential_read*) echo "read" ;;
        sequential_write*) echo "write" ;;
        mixed_read_write*) echo "rw" ;;
        *) echo "Unsupported test: $1" >&2; exit 1 ;;
    esac
}

# Iterate through each test and append results to CSV
for test_name in "${tests[@]}"; do
    rw=$(translate_to_rw ${test_name})
    numjobs=$(echo ${test_name} | grep -oP '(?<=_)\d+$') || 1

    # Run the fio test and output to JSON file
    fio --output-format=json \
        --name=${test_name} \
        --rw=${rw} \
        --bs=4k \
        --direct=1 \
        --size=512M \
        --numjobs=${numjobs:-1} \
        --runtime=30s \
        --filename=${TESTFILE} > "${test_name}.json"

    # Extract the results and append to the CSV file
    jq -r '[.jobs[0].jobname, (.jobs[0].read.iops // 0), (.jobs[0].write.iops // 0)] | @csv' "${test_name}.json" >> fio_results.csv
done

echo "All tests completed! Check 'fio_results.csv' for the test results."
