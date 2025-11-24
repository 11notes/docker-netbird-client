![banner](https://raw.githubusercontent.com/11notes/static/refs/heads/main/img/banner/README.png)

# NETBIRD-CLIENT
![size](https://img.shields.io/badge/image_size-31MB-green?color=%2338ad2d)![5px](https://raw.githubusercontent.com/11notes/static/refs/heads/main/img/markdown/transparent5x2px.png)![pulls](https://img.shields.io/docker/pulls/11notes/netbird-client?color=2b75d6)![5px](https://raw.githubusercontent.com/11notes/static/refs/heads/main/img/markdown/transparent5x2px.png)[<img src="https://img.shields.io/github/issues/11notes/docker-netbird-client?color=7842f5">](https://github.com/11notes/docker-netbird-client/issues)![5px](https://raw.githubusercontent.com/11notes/static/refs/heads/main/img/markdown/transparent5x2px.png)![swiss_made](https://img.shields.io/badge/Swiss_Made-FFFFFF?labelColor=FF0000&logo=data:image/svg%2bxml;base64,PHN2ZyB2ZXJzaW9uPSIxIiB3aWR0aD0iNTEyIiBoZWlnaHQ9IjUxMiIgdmlld0JveD0iMCAwIDMyIDMyIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgogIDxyZWN0IHdpZHRoPSIzMiIgaGVpZ2h0PSIzMiIgZmlsbD0idHJhbnNwYXJlbnQiLz4KICA8cGF0aCBkPSJtMTMgNmg2djdoN3Y2aC03djdoLTZ2LTdoLTd2LTZoN3oiIGZpbGw9IiNmZmYiLz4KPC9zdmc+)

Run netbird client rootless.

# INTRODUCTION 📢

[NetBird](https://github.com/netbirdio/netbird) (created by [netbird](https://github.com/netbirdio)) combines a WireGuard-based overlay network with Zero Trust Network Access, providing a unified open source platform for reliable and secure connectivity. Create your own selfhosted ZTNA mesh network.

# SYNOPSIS 📖
**What can I do with this?** This image will run the Netbird client as a container [rootless](https://github.com/11notes/RTFM/blob/main/linux/container/image/rootless.md). Generating a [setup key](https://docs.netbird.io/how-to/register-machines-using-setup-keys) is all you need to do.

# UNIQUE VALUE PROPOSITION 💶
**Why should I run this image and not the other image(s) that already exist?** Good question! Because ...

> [!IMPORTANT]
>* ... this image runs [rootless](https://github.com/11notes/RTFM/blob/main/linux/container/image/rootless.md) as 1000:1000
>* ... this image is auto updated to the latest version via CI/CD
>* ... this image has a health check
>* ... this image runs read-only
>* ... this image is automatically scanned for CVEs before and after publishing
>* ... this image is created via a secure and pinned CI/CD process
>* ... this image is very small

If you value security, simplicity and optimizations to the extreme, then this image might be for you.

# COMPARISON 🏁
Below you find a comparison between this image and the most used or original one.

| **image** | **size on disk** | **init default as** | **[distroless](https://github.com/11notes/RTFM/blob/main/linux/container/image/distroless.md)** | supported architectures
| ---: | ---: | :---: | :---: | :---: |
| 11notes/netbird-client | 31MB | 1000:1000 | ❌ | amd64, arm64, armv7 |
| netbirdio/netbird | 49MB | 0:0 | ❌ | amd64, arm64, armv7 |

# VOLUMES 📁
* **/netbird/etc** - Directory of your client configs

# COMPOSE ✂️
```yaml
name: "netbird"

x-lockdown: &lockdown
  # prevents write access to the image itself
  read_only: true
  # prevents any process within the container to gain more privileges
  security_opt:
    - "no-new-privileges=true"

services:
  client:
    image: "11notes/netbird-client:0.60.2"
    <<: *lockdown
    environment:
      TZ: "Europe/Zurich"
      NETBIRD_PEER_NAME: "docker"
      NETBIRD_URL: "${NETBIRD_URL}"
      NETBIRD_SETUP_KEY: "${NETBIRD_SETUP_KEY}"
    volumes:
      - "netbird.etc:/netbird/etc"
    tmpfs:
      - "/run:uid=1000,gid=1000"
    networks:
      frontend:
    restart: "always"

volumes:
  netbird.etc:

networks:
  frontend:
```
To find out how you can change the default UID/GID of this container image, consult the [RTFM](https://github.com/11notes/RTFM/blob/main/linux/container/image/11notes/how-to.changeUIDGID.md#change-uidgid-the-correct-way).

# DEFAULT SETTINGS 🗃️
| Parameter | Value | Description |
| --- | --- | --- |
| `user` | docker | user name |
| `uid` | 1000 | [user identifier](https://en.wikipedia.org/wiki/User_identifier) |
| `gid` | 1000 | [group identifier](https://en.wikipedia.org/wiki/Group_identifier) |
| `home` | /netbird | home directory of user docker |

# ENVIRONMENT 📝
| Parameter | Value | Default |
| --- | --- | --- |
| `TZ` | [Time Zone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) | |
| `DEBUG` | Will activate debug option for container image and app (if available) | |

# MAIN TAGS 🏷️
These are the main tags for the image. There is also a tag for each commit and its shorthand sha256 value.

* [0.60.2](https://hub.docker.com/r/11notes/netbird-client/tags?name=0.60.2)

### There is no latest tag, what am I supposed to do about updates?
It is my opinion that the ```:latest``` tag is a bad habbit and should not be used at all. Many developers introduce **breaking changes** in new releases. This would messed up everything for people who use ```:latest```. If you don’t want to change the tag to the latest [semver](https://semver.org/), simply use the short versions of [semver](https://semver.org/). Instead of using ```:0.60.2``` you can use ```:0``` or ```:0.60```. Since on each new version these tags are updated to the latest version of the software, using them is identical to using ```:latest``` but at least fixed to a major or minor version. Which in theory should not introduce breaking changes.

If you still insist on having the bleeding edge release of this app, simply use the ```:rolling``` tag, but be warned! You will get the latest version of the app instantly, regardless of breaking changes or security issues or what so ever. You do this at your own risk!

# REGISTRIES ☁️
```
docker pull 11notes/netbird-client:0.60.2
docker pull ghcr.io/11notes/netbird-client:0.60.2
docker pull quay.io/11notes/netbird-client:0.60.2
```

# SOURCE 💾
* [11notes/netbird-client](https://github.com/11notes/docker-netbird-client)

# PARENT IMAGE 🏛️
> [!IMPORTANT]
>This image is not based on another image but uses [scratch](https://hub.docker.com/_/scratch) as the starting layer.

# BUILT WITH 🧰
* [netbirdio/netbird](https://github.com/netbirdio/netbird)

# GENERAL TIPS 📌
> [!TIP]
>* Use a reverse proxy like Traefik, Nginx, HAproxy to terminate TLS and to protect your endpoints
>* Use Let’s Encrypt DNS-01 challenge to obtain valid SSL certificates for your services

# CAUTION ⚠️
> [!CAUTION]
>* This image is rootless and runs in userspace (not kernel space). Use this image as an **exit node** or attach to another container to expose that container via Netbird

# ElevenNotes™️
This image is provided to you at your own risk. Always make backups before updating an image to a different version. Check the [releases](https://github.com/11notes/docker-netbird-client/releases) for breaking changes. If you have any problems with using this image simply raise an [issue](https://github.com/11notes/docker-netbird-client/issues), thanks. If you have a question or inputs please create a new [discussion](https://github.com/11notes/docker-netbird-client/discussions) instead of an issue. You can find all my other repositories on [github](https://github.com/11notes?tab=repositories).

*created 24.11.2025, 03:02:30 (CET)*