# syntax = devthefuture/dockerfile-x
FROM ./base/ubuntu.dockerfile

ARG DEBIAN_FRONTEND="noninteractive"
RUN apt-get install -y \
  python3 \
  && apt-get clean

COPY --chmod=755 ./nodejs/root /
