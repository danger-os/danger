ARG BUILD_DIR=/var/danger

FROM ubuntu:18.04
ARG BUILD_DIR

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
                    binutils-aarch64-linux-gnu \
                    gdc-aarch64-linux-gnu \
                    git \
                    make \
                    vim && \
    rm -rf /var/lib/apt/lists/*
    
RUN mkdir -p $BUILD_DIR

WORKDIR $BUILD_DIR