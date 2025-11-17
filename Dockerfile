# 文件名：Dockerfile
FROM alpine:3.20

# 安装 ping 和 nslookup
# ping 在 iputils 包里，nslookup 在 bind-tools 包里
RUN apk add --no-cache iputils bind-tools

# 默认进到 sh，方便调试
CMD ["/bin/sh"]
