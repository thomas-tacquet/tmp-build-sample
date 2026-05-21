# Start with your real-world compilation environment
FROM golang:1.23-alpine

# Install git and bash (needed for cloning and script execution)
RUN apk add --no-cache git bash

# Pull the static Kaniko binaries directly from the official image
COPY --from=gcr.io/kaniko-project/executor:debug /kaniko/executor /kaniko/executor

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
