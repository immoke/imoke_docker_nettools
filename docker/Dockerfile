# 文件名：Dockerfile
FROM alpine:3.22

# 安装所需网络工具：
# ping        -> iputils
# nslookup    -> bind-tools
# traceroute  -> traceroute
# whois       -> whois
# telnet      -> busybox-extras（带 telnet）
# nmap        -> nmap
# ssh/sshd    -> openssh
RUN apk add --no-cache \
    iputils \
    bind-tools \
    traceroute \
    whois \
    busybox-extras \
    nmap \
    openssh

# 为 sshd 准备运行目录
RUN mkdir -p /var/run/sshd

# 复制入口脚本
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# 默认入口：先执行 entrypoint，再执行 CMD
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/sh"]
