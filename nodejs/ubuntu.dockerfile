# syntax = devthefuture/dockerfile-x
FROM ./base/ubuntu.dockerfile

COPY --chmod=755 ./nodejs/root /
