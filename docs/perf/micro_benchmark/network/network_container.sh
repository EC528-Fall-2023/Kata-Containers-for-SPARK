#!/bin/bash

# Deploy Docker Containers for Performance Testing

# Define variables
NETWORK_NAME="perf-kata-network"
KATA1_CONTAINER="kata1-network"
KATA1_CONTAINER_ENABLE="kata1-network-enable"
KATA1_IMAGE="perf-kata1-image"
DEFAULT_RUNTIME="result_default.txt"
KATA_RUNTIME="result_kata.txt"
DOCKERFILE="DockerfileKata1"
HOSTNAME=$(hostname)
# KATA2_CONTAINER="kata2-6"
# KATA2_IMAGE="perf-kata2-image"

sudo docker build -t $KATA1_IMAGE -f $DOCKERFILE .
sudo docker network create perf-kata-network
echo "Starting the deployment of Docker containers with default runtime"

# Run kata1 container with default runtime
sudo docker run --name $KATA1_CONTAINER -p 5201:5201 --network $NETWORK_NAME -d $KATA1_IMAGE

# Run kata2 container
# sudo docker run --name $KATA2_CONTAINER --network $NETWORK_NAME -d $KATA2_IMAGE

# Optional: wait for a few seconds to ensure containers are up and running
sleep 15

# Display logs from kata2 container
# sudo docker logs $KATA2_CONTAINER

iperf3 -c $HOSTNAME > $DEFAULT_RUNTIME

echo "Deployment default runtime container complete."
# Stop and remove the kata1 container
echo "Stopping container $KATA1_CONTAINER..."
sudo docker stop $KATA1_CONTAINER
sudo docker rm $KATA1_CONTAINER

echo "Containers stopped and removed."

echo "Starting the deployment of Docker containers with kata runtime"

# Run kata1 container with kata-runtime
sudo docker run --name $KATA1_CONTAINER_ENABLE -p 5201:5201 --network $NETWORK_NAME --runtime io.containerd.kata.v2 -d $KATA1_IMAGE

# Run kata2 container with kata-runtime
# sudo docker run --name $KATA2_CONTAINER --network $NETWORK_NAME --runtime io.containerd.kata.v2 -d $KATA2_IMAGE

# Optional: wait for a few seconds to ensure containers are up and running
sleep 15

# Display logs from kata2 container
# sudo docker logs $KATA2_CONTAINER

iperf3 -c $HOSTNAME > $KATA_RUNTIME

echo "Deployment kata runtime container complete."
# Stop and remove the kata1 container
echo "Stopping container $KATA1_CONTAINER_KATA..."
sudo docker stop $KATA1_CONTAINER_ENABLE
sudo docker rm $KATA1_CONTAINER_ENABLE

echo "Deployment complete."