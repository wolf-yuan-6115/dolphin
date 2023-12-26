# syntax = devthefuture/dockerfile-x
FROM ./base/alpine.dockerfile

RUN apk add --update --no-cache --virtual build-dependencies \
  python3

COPY --chmod=755 ./nodejs/root /
