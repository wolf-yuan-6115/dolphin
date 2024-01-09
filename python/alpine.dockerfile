FROM wolfyuan/dolphin:base-alpine

# https://github.com/pyenv/pyenv/wiki#suggested-build-environment
RUN apk add --update --no-cache --virtual build-dependencies \
  git \
  bash \
  build-base \
  libffi-dev \
  openssl-dev \
  bzip2-dev \
  zlib-dev \
  xz-dev \
  readline-dev \
  sqlite-dev \
  tk-dev

COPY --chmod=755 ./python/root /
