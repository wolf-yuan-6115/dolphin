# 📙 Contributing this project

You should follow these rules:

- This project uses [commitizen](https://commitizen-tools.github.io/commitizen), commit messages should be lowercase.
- Commands arguments should be expanded when possible. For example, `git commit -a` should be `git commit --all`
- s6 service script should match these requirements:
  - for base image: `init-*`, for example `init-my-service`
  - for other images: `[image name]-*`, for example, node image should have `node-my-service`
- Containers should support controlling environment via environment variables
- Command step outputs should start with these symbol:
  - Regular info or indicating adding packages/code to container: `[+]`
  - Skipping step or indicating removing packages/code from container: `[-]`
  - Error or indicating facing some failure: `[x]`
- Writing workflow on `README.md` is not required.

Additional notes:
- If you want to add new platform, please submit an issue first.
- If you want to support new base image, please sumbit an issue first.

Notes for developing new container image:
- Alpine based images uses `musl` instead of `glibc`, support them at your best. (Most software have `musl` build for x86 systems.)
- After base image init done, `init-done` service will be ran, when your extended image done initializing environment, you should call `extend-init-done`
- When building only one image for testing, you can use command below:
  - Building container image:
    ```
    docker buildx build --platform linux/amd64 -t dolphin:<image tag> -f <path to docker file> . --load
    ```
