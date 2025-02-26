FROM alpine:3.17 as builder

# Install dependencies for downloading and extracting
RUN apk add --no-cache wget tar

# Set the BBMap version
ENV BBMAP_VERSION=39.18

# Download and extract BBMap
RUN wget https://sourceforge.net/projects/bbmap/files/BBMap_${BBMAP_VERSION}.tar.gz/download -O BBMap_${BBMAP_VERSION}.tar.gz && \
    tar -xzf BBMap_${BBMAP_VERSION}.tar.gz && \
    rm BBMap_${BBMAP_VERSION}.tar.gz

# Second stage: minimal runtime image
FROM eclipse-temurin:11-jre-alpine

# Copy BBMap from the builder stage
COPY --from=builder /bbmap /bbmap

# Add BBMap to PATH
ENV PATH="/bbmap:${PATH}"

# Verify BBMap installation and file structure
RUN ls -la /bbmap && \
    find /bbmap -name "*.sh" -type f -exec chmod +x {} \;

# Create a working directory
WORKDIR /data

# Create a simpler entrypoint script
RUN echo '#!/bin/sh' > /entrypoint.sh && \
    echo 'if [ "$1" = "" ]; then' >> /entrypoint.sh && \
    echo '  exec sh /bbmap/bbmap.sh --help' >> /entrypoint.sh && \
    echo 'elif [ -f "/bbmap/$1" ]; then' >> /entrypoint.sh && \
    echo '  TOOL=$1' >> /entrypoint.sh && \
    echo '  shift' >> /entrypoint.sh && \
    echo '  exec sh /bbmap/$TOOL $@' >> /entrypoint.sh && \
    echo 'else' >> /entrypoint.sh && \
    echo '  exec sh /bbmap/bbmap.sh $@' >> /entrypoint.sh && \
    echo 'fi' >> /entrypoint.sh && \
    chmod +x /entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Default command shows help
CMD [""]
