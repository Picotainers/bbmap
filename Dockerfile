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

# Copy only the necessary files from the builder stage
COPY --from=builder /bbmap /bbmap

# Add BBMap to PATH
ENV PATH="/bbmap:${PATH}"

# Create a working directory
WORKDIR /data

# Create a wrapper script to allow running any BBMap tool
RUN echo '#!/bin/sh' > /entrypoint.sh && \
    echo 'if [ -f "/bbmap/$1" ]; then' >> /entrypoint.sh && \
    echo '  exec "/bbmap/$@"' >> /entrypoint.sh && \
    echo 'else' >> /entrypoint.sh && \
    echo '  exec "/bbmap/bbmap.sh" "$@"' >> /entrypoint.sh && \
    echo 'fi' >> /entrypoint.sh && \
    chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

# List available tools by default
CMD ["bbmap.sh", "--help"]
