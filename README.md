# IMOKE & IDEER 网络调试docker
一个专门用来调试网络的docker镜像，
基于 `alpine:3.22` 镜像制作，安装了一些常用的网络命令，并且支持ssh直接登陆。

#### 已安装命令如下
- `ping`
- `nslookup`
- `traceroute`
- `whois`
- `telnet`
- `nmap`


#### 部署命令：
```
docker run -i -t -d \
  --restart=always \
  --name imoke_nettools \
  -e TZ=Asia/Shanghai \
  -e ssh_username=testuser \
  -e ssh_password=Test1234 \
  -e ssh_port=2222 \
  -p 2222:2222 \
  imoke/imoke_nettools:latest
```
> 注：如果不提供 ssh_username / ssh_password / ssh_port 参数则不开启SSH，也无需映射端口。