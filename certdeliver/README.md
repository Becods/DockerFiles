<div align="center">

# CertDeliver

_✨ Muir证书分发 ✨_

灵感来源于 acmeDeliver | 基于 acme.sh && php

作为 MuirNGMI 的子项目独立开源于 Dockerfile

</div>

### Usage
```
#服务端启动守护程序
docker run -itd  \
  -v "$(pwd)/out":/acme.sh  \
  --net=host \
  --name=certdeliver \
  -e PASSWORD=Please-Change-Me
  becod/certdeliver daemon

#签发证书
docker exec certdeliver --issue -d example.com --standalone

#客户端获取证书
docker run --rm -it \
  -v "$(pwd)/out":/acme.sh \
  --net=host \
  --name=certdeliver \
  becod/certdeliver get -h
```
