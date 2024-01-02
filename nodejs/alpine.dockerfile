# syntax = devthefuture/dockerfile-x
FROM ./base/alpine.dockerfile

COPY --chmod=755 ./nodejs/root /
