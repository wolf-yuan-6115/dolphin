FROM ubuntu:mantic

ARG BUILD_DATE
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.name="wolf-yuan/dolphin:base-ubuntu"
LABEL org.label-schema.description="Multi usage container image for hosting various applications"
LABEL org.label-schema.vcs-url="https://gitlab.com/wolf-yuan/dolphin"

ARG S6_OVERLAY_VERSION=3.1.6.2 DEBIAN_FRONTEND="noninteractive"

RUN echo "[+] Installing base dependencies" \
  && apt-get update && apt-get upgrade -y && apt-get install -y \
  apt-utils \
  locales \
  curl \
  gnupg \
  jq \
  tzdata \
  git \
  xz-utils \
  && apt-get clean \
  && echo "[+] Generating locales" \
  && locale-gen en_US.UTF-8 \
  && export PLATFORM=$(uname -m | sed 's/armv7l/arm/') \
  && echo "[+] Downloading s6 overlay" \
  && curl -fsSL https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz -o /tmp/s6-overlay-noarch.tar.xz \
  && curl -fsSL https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${PLATFORM}.tar.xz -o /tmp/s6-overlay-${PLATFORM}.tar.xz \
  && echo "[+] Downloading s6 symlinks" \
  && curl -fsSL https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-noarch.tar.xz -o /tmp/s6-overlay-symlinks-noarch.tar.xz \
  && curl -fsSL https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-arch.tar.xz -o /tmp/s6-overlay-symlinks-arch.tar.xz \
  && echo "[+] Installing s6 overlay" \
  && tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz \
  && tar -C / -Jxpf /tmp/s6-overlay-${PLATFORM}.tar.xz \
  && tar -C / -Jxpf /tmp/s6-overlay-symlinks-noarch.tar.xz \
  && tar -C / -Jxpf /tmp/s6-overlay-symlinks-arch.tar.xz \
  && echo "[+] Creating group" \
  && groupadd --gid 1500 dolphin \
  && echo "[+] Creating user" \
  && useradd --home /home/dolphin --uid 1500 --shell /usr/bin/bash --gid dolphin --system dolphin \
  && echo "[+] Creating bashrc" \
  && touch ~/.bashrc

ENV S6_VERBOSITY=1 \
  S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
  S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0 \
  SHELL=/bin/bash
COPY --chmod=755 ./base/root /

ENTRYPOINT ["/init"]
