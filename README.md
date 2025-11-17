# IMOKE & IDEER 网络调试docker
```
docker run -it \
  -e ssh_username=testuser \
  -e ssh_password=Test1234 \
  -e ssh_port=2222 \
  -p 2222:2222 \
  imoke/imoke_nettools:latest
```