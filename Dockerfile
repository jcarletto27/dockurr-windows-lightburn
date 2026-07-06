FROM dockurr/windows

# Copy our custom startup script into the Linux container
COPY custom-entrypoint.sh /custom-entrypoint.sh

# Ensure it is executable
RUN chmod +x /custom-entrypoint.sh

# Override the default entrypoint so our script runs first
ENTRYPOINT ["/custom-entrypoint.sh"]
