FROM ghcr.io/sagernet/sing-box:latest
COPY config.json /etc/sing-box/config.json
ENTRYPOINT ["/usr/local/bin/sing-box", "run", "-c", "/etc/sing-box/config.json"]
