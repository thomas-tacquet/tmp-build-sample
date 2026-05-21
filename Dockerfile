# Safe alternative to Alpine that completely bypasses the gVisor chown bug
FROM busybox:musl

# Create a simple script inside the image
RUN echo 'echo "Hello from an image built entirely inside Scaleway Serverless Jobs!"' > /run.sh
RUN chmod +x /run.sh

# Run the script on boot
CMD ["/bin/sh", "/run.sh"]
