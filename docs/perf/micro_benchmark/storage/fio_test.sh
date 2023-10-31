#!/bin/bash

# Path to the test file
TESTFILE="/test/fiotestfile"
# Check if the directory exists, if not, create it
TESTDIR=$(dirname ${TESTFILE})
if [ ! -d "${TESTDIR}" ]; then
    echo "Directory ${TESTDIR} does not exist. Creating..."
    mkdir -p "${TESTDIR}"
fi

# Random Read Test
fio --name=random_read_test --rw=randread --bs=4k --direct=1 --size=512M --numjobs=1 --runtime=30s --filename=${TESTFILE}

# Random Write Test
fio --name=random_write_test --rw=randwrite --bs=4k --direct=1 --size=512M --numjobs=1 --runtime=30s --filename=${TESTFILE}

# Sequential Read Test
fio --name=sequential_read_test --rw=read --bs=1M --direct=1 --size=512M --numjobs=1 --runtime=30s --filename=${TESTFILE}

# Sequential Write Test
fio --name=sequential_write_test --rw=write --bs=1M --direct=1 --size=512M --numjobs=1 --runtime=30s --filename=${TESTFILE}

# Random Read Multi-Threaded Test
fio --name=random_read_multi_threaded_test --rw=randread --bs=4k --direct=1 --size=512M --numjobs=4 --runtime=30s --filename=${TESTFILE}

# Random Write Multi-Threaded Test
fio --name=random_write_multi_threaded_test --rw=randwrite --bs=4k --direct=1 --size=512M --numjobs=4 --runtime=30s --filename=${TESTFILE}

# Mixed Read/Write Test
fio --name=mixed_read_write_test --rw=randrw --rwmixread=70 --bs=4k --direct=1 --size=512M --numjobs=1 --runtime=30s --filename=${TESTFILE}

# Done
echo "All tests completed!"
