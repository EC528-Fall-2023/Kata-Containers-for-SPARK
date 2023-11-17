#!/bin/bash

# Define variables
IMAGE_NAME="stress-test-image"
DOCKERFILE="DockerfileCPU"
SCRIPT_NAME="stress_tests.sh"
RESULTS_DIR="./stress_test_results"
RESULTS_KATA_DIR="./stress_test_results_kata"

# Step 1: Build the Docker Image
echo "Building the Docker image..."
sudo docker build -t $IMAGE_NAME -f $DOCKERFILE .

# Step 2: Run the container with volume mount
echo "Running the container with default runtime"
CONTAINER_ID=$(docker run -d -v $(pwd)/$RESULTS_DIR:/data/stress_test_results $IMAGE_NAME)

echo "Container started with ID $CONTAINER_ID"

# Wait for the test to complete
echo "Waiting for the test to complete..."
sudo docker wait $CONTAINER_ID

# Step 3: Stop and remove the container
echo "Stopping and removing the container..."
sudo docker stop $CONTAINER_ID
sudo docker rm $CONTAINER_ID


# Step 2: Run the container with volume mount
echo "Running the container with kata runtime"
CONTAINER_ID=$(docker run --runtime io.containerd.kata.v2 -d -v $(pwd)/$RESULTS_KATA_DIR:/data/stress_test_results $IMAGE_NAME)

echo "Container started with ID $CONTAINER_ID"

# Wait for the test to complete
echo "Waiting for the test to complete..."
sudo docker wait $CONTAINER_ID

# Step 3: Stop and remove the container
echo "Stopping and removing the container..."
sudo docker stop $CONTAINER_ID
sudo docker rm $CONTAINER_ID

echo "Performance test completed. Check the results in $RESULTS_KATA_DIR."
