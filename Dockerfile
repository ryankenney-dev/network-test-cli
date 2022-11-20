FROM ubuntu:20.04

COPY --chown=root:root entrypoint-curl-urls.sh /

RUN set -x && \
    # Set perms on added files (umask can vary host-to-host)
    chmod 0640 /entrypoint-curl-urls.sh && \
    # Install tools
    apt-get update && \
    apt-get -y install curl && \
    # Wipe apt cache to minimize image
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/bin/bash", "/entrypoint-curl-url.sh"]
