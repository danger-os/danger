#!/bin/bash

# Docker Image Properties
IMAGE_NAME=danger-os/builder
IMAGE_VERSION=dangerous
IMAGE_TAG=$IMAGE_PREFIX$IMAGE_VERSION

# Configure properties
BUILD_ROOT=/var/danger

# Variables
DOCKER_DIR=$(dirname $0)
PROJECT_ROOT=$(realpath $DOCKER_DIR/../)

echo "Building image $IMAGE_NAME:$IMAGE_TAG"
docker build -t $IMAGE_NAME:$IMAGE_TAG \
            -f $DOCKER_DIR/Dockerfile \
            $(dirname $0)

echo "Mounting $PROJECT_ROOT to $BUILD_ROOT"
docker run  -it \
            --rm \
            --user `id -u`:`id -g` \
            --volume $PROJECT_ROOT:$BUILD_ROOT \
            $IMAGE_NAME:$IMAGE_TAG
