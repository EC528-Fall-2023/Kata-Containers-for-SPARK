#!/bin/bash

# Install required packages
sudo apt update
sudo apt install -y fio gnuplot jq

# Define file path for disk I/O tests
TESTFILE="/path/to/testfile"
TESTDIR=$(dirname ${TESTFILE})
if [ ! -d "${TESTDIR}" ]; then
    echo "Directory ${TESTDIR} does not exist. Creating it..."
    mkdir -p "${TESTDIR}"
fi

# Run disk I/O tests with fio
echo "Starting Disk I/O tests..."

fio --output-format=json --name=random_read_test --rw=randread --bs=4k --direct=1 --size=512M --numjobs=1 --runtime=30s --filename=${TESTFILE} > fio_random_read.json
fio --output-format=json --name=random_write_test --rw=randwrite --bs=4k --direct=1 --size=512M --numjobs=1 --runtime=30s --filename=${TESTFILE} > fio_random_write.json
fio --output-format=json --name=sequential_read_test --rw=read --bs=1M --direct=1 --size=512M --numjobs=1 --runtime=30s --filename=${TESTFILE} > fio_sequential_read.json
fio --output-format=json --name=sequential_write_test --rw=write --bs=1M --direct=1 --size=512M --numjobs=1 --runtime=30s --filename=${TESTFILE} > fio_sequential_write.json
fio --output-format=json --name=random_read_multi_threaded_test --rw=randread --bs=4k --direct=1 --size=512M --numjobs=4 --runtime=30s --filename=${TESTFILE} > fio_random_read_multi.json
fio --output-format=json --name=random_write_multi_threaded_test --rw=randwrite --bs=4k --direct=1 --size=512M --numjobs=4 --runtime=30s --filename=${TESTFILE} > fio_random_write_multi.json
fio --output-format=json --name=mixed_read_write_test --rw=randrw --rwmixread=70 --bs=4k --direct=1 --size=512M --numjobs=1 --runtime=30s --filename=${TESTFILE} > fio_mixed.json

# Parse the output and generate charts for I/O tests
echo "Generating graphs..."

# Use jq to parse the JSON output from fio and create an output file for each test
for f in fio_*.json; do
    jq -r '.jobs[0] | "\(.jobname) \(.read.iops) \(.write.iops)"' "$f" >> fio_results.txt
done

# Use gnuplot to generate a graph
gnuplot <<- EOF
    set terminal png size 800,600
    set output 'fio_results.png'
    set title 'fio Benchmark Results'
    set ylabel 'IOPS'
    set xtics rotate by -45
    set grid
    set boxwidth 0.7 relative
    set style data histograms
    set style histogram cluster gap 1
    set style fill solid border -1
    plot 'fio_results.txt' using 2:xtic(1) title 'Read', 'fio_results.txt' using 3:xtic(1) title 'Write'
EOF

echo "All tests completed! Check 'fio_results.png' for the graph."
