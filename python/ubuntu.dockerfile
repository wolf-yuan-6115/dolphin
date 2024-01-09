FROM wolfyuan/dolphin:base-ubuntu

ARG DEBIAN_FRONTEND="noninteractive"
# https://github.com/pyenv/pyenv/wiki#suggested-build-environment
RUN apt-get install -y \
  build-essential \
  libssl-dev \
  zlib1g-dev \
  libbz2-dev \
  libreadline-dev \
  libsqlite3-dev \
  curl \
  libncursesw5-dev \
  xz-utils \
  tk-dev \
  libxml2-dev \
  libxmlsec1-dev \
  libffi-dev \
  liblzma-dev \
  && apt-get clean

COPY --chmod=755 ./python/root /
