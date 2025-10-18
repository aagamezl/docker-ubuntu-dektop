# docker-vnc

## Description

This repository contains a Dockerfile and a docker-compose.yml file to create a VNC server using Ubuntu 22.04.


# Usage

```bash
./restart.sh
```

```bash
docker-compose up -d
```

```bash
docker-compose down
```

```bash
docker run -d -p 33900:3389 --name remote-desktop remote-desktop
```

##
https://docs.anduinos.com/Skills/Sandboxing/Remote-Desktop-To-Ubuntu-Container.html#method-2-build-the-image-yourself