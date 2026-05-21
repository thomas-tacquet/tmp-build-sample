# 1. Use the official Google Distroless static image as the base
# This image contains only the minimal layout required for an application to run
FROM gcr.io/distroless/static-debian12

# 2. Set a secure working directory
WORKDIR /app

# 3. Copy your application file(s) from your repository context
# (Replace "app.js" or "hello-binary" with your actual file)
COPY hello-executable /app/hello-executable

# 4. Configure the execution entrypoint
# Since Distroless does not include a shell (/bin/sh), you must execute your binary/runtime directly
ENTRYPOINT ["/app/hello-executable"]
