#!/bin/sh
set -e

# 支持大小写两种环境变量名，方便你用：
# ssh_username / ssh_password / ssh_port
SSH_USERNAME=${SSH_USERNAME:-$ssh_username}
SSH_PASSWORD=${SSH_PASSWORD:-$ssh_password}
SSH_PORT=${SSH_PORT:-$ssh_port}
: "${SSH_PORT:=2222}"  # 如果没设置端口，默认 2222

enable_ssh=0
if [ -n "$SSH_USERNAME" ] && [ -n "$SSH_PASSWORD" ]; then
  enable_ssh=1
fi

if [ "$enable_ssh" -eq 1 ]; then
  echo "[entrypoint] 启用 SSH：用户=$SSH_USERNAME，端口=$SSH_PORT"

  # 如果用户不存在则创建
  if ! id "$SSH_USERNAME" >/dev/null 2>&1; then
    adduser -D -s /bin/sh "$SSH_USERNAME"
  fi

  # 设置密码
  echo "$SSH_USERNAME:$SSH_PASSWORD" | chpasswd

  # 配置 sshd_config 中的端口
  if grep -q "^Port " /etc/ssh/sshd_config 2>/dev/null; then
    sed -i "s/^Port .*/Port $SSH_PORT/" /etc/ssh/sshd_config
  else
    echo "Port $SSH_PORT" >> /etc/ssh/sshd_config
  fi

  # 启用密码登录
  if grep -q "^#PasswordAuthentication" /etc/ssh/sshd_config 2>/dev/null; then
    sed -i "s/^#PasswordAuthentication.*/PasswordAuthentication yes/" /etc/ssh/sshd_config
  elif grep -q "^PasswordAuthentication" /etc/ssh/sshd_config 2>/dev/null; then
    sed -i "s/^PasswordAuthentication.*/PasswordAuthentication yes/" /etc/ssh/sshd_config
  else
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
  fi

  # 不允许 root 远程登录（安全一点）
  if grep -q "^#PermitRootLogin" /etc/ssh/sshd_config 2>/dev/null; then
    sed -i "s/^#PermitRootLogin.*/PermitRootLogin no/" /etc/ssh/sshd_config
  elif grep -q "^PermitRootLogin" /etc/ssh/sshd_config 2>/dev/null; then
    sed -i "s/^PermitRootLogin.*/PermitRootLogin no/" /etc/ssh/sshd_config
  else
    echo "PermitRootLogin no" >> /etc/ssh/sshd_config
  fi

  # 生成 host key（如果不存在）
  ssh-keygen -A

  # 启动 sshd（后台）
  /usr/sbin/sshd
else
  echo "[entrypoint] 未配置 ssh_username 或 ssh_password，SSH 不启动。"
fi

# 继续执行容器原本的 CMD
exec "$@"
