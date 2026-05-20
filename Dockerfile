# 第一阶段：从官方云端拉取 cloudflared 提取二进制文件
FROM cloudflare/cloudflared:latest AS tunnel

# 第二阶段：主环境基于原生的 Alpine Linux
FROM alpine:latest

# 安装 sing-box 依赖环境
RUN apk add --no-cache ca-certificates libc6-compat

# 从官方源以及第一阶段中，分别拷入最新的核心程序
COPY --from=ghcr.io/sagernet/sing-box:latest /usr/local/bin/sing-box /usr/local/bin/sing-box
COPY --from=tunnel /usr/local/bin/cloudflared /usr/local/bin/cloudflared

COPY config.json /etc/sing-box/config.json

# 强行拉起双进程常驻：用后台守护进程同时启动隧道和核心
CMD ["sh", "-c", "sing-box run -c /etc/sing-box/config.json & cloudflared tunnel --no-autoupdate run --token ${TUNNEL_TOKEN}"]
