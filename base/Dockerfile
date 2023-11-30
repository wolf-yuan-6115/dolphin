# syntax = devthefuture/dockerfile-x
FROM alpine:3

ARG S6_OVERLAY_VERSION=3.1.6.2

RUN apk add --update --no-cache --virtual base-dependencies \
  build-base \
  gcc \
  wget \
  curl \
  git \
  g++

RUN export PLATFORM=$(uname -m) \
  && curl -fsSL https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz -o /tmp/s6-overlay-noarch.tar.xz \
  && curl -fsSL https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${PLATFORM}.tar.xz -o /tmp/s6-overlay-${PLATFORM}.tar.xz \
  && curl -fsSL https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-noarch.tar.xz -o /tmp/s6-overlay-symlinks-noarch.tar.xz \
  && curl -fsSL https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-arch.tar.xz -o /tmp/s6-overlay-symlinks-arch.tar.xz \
  && tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz \
  && tar -C / -Jxpf /tmp/s6-overlay-${PLATFORM}.tar.xz \
  && tar -C / -Jxpf /tmp/s6-overlay-symlinks-noarch.tar.xz \
  && tar -C / -Jxpf /tmp/s6-overlay-symlinks-arch.tar.xz

ENTRYPOINT ["/init"]