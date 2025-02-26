FROM ubuntu:20.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Set up locale
RUN apt-get update && apt-get install -y locales && \
    locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

# Install dependencies
RUN apt-get update && apt-get install -y \
    openjdk-11-jre \
    wget \
    unzip \
    python3 \
    python3-pip \
    git \
    gcc \
    make \
    libbz2-dev \
    zlib1g-dev \
    libncurses5-dev \
    libncursesw5-dev \
    liblzma-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set the BBMap version
ENV BBMAP_VERSION=38.97

# Download and install BBMap
RUN wget https://sourceforge.net/projects/bbmap/files/BBMap_${BBMAP_VERSION}.tar.gz/download -O BBMap_${BBMAP_VERSION}.tar.gz && \
    tar -xvzf BBMap_${BBMAP_VERSION}.tar.gz && \
    rm BBMap_${BBMAP_VERSION}.tar.gz

# Add BBMap to PATH
ENV PATH="/bbmap:${PATH}"

# Create a working directory
WORKDIR /data

# Create entry point that runs bbmap.sh by default
ENTRYPOINT ["/bbmap/bbmap.sh"]
