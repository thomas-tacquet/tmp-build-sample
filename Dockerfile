# Starts with a completely empty filesystem layer—no unpacking required
FROM scratch

# Copy a static file or a statically-compiled binary from your build context
COPY application-asset.txt /application-asset.txt

# (Optional) If copying a statically compiled binary (Go/Rust/C++ with zero dynamic links)
# COPY my-static-binary /my-static-binary
# ENTRYPOINT ["/my-static-binary"]
