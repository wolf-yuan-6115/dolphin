# 🐬 Dolphin
## All-in-one solution for hosting your code

> Dolphin is still under heavy development, please create an issue if you face any bugs or request a feature

Dolphin is a cool container image that prepared everything for you!

✨ Features:
- Container running with `s6-overlay`
- Modular design
- Support a wide variety of language
- Multi-base image and CPU architecture
- Code runs in a rootless process

---

- [🏃 Running image](#🏃-running-image)
- [📦️ Container images](#📦️-container-images)
  - [Tagging format](#tagging-format)
- [🌎️ Environment variables and workflow](#🌎️-environment-variables-and-workflow)
  - [Variables that apply to every image](#applies-to-every-image)
  - [Image specific options](#image-specific-options)
- [💾 Persist data inside container](#💾-persist-data-inside-container)
- [🎩 RedHat Podman support](#🎩-redhat-podman-support)
- [📽️ Graphics card support](#📽️-graphics-card-support)

## 🏃 Running image

```bash
docker run --name dolphin-box -d \
  -e GIT_URL="https://domain.com" \
  --restart unless-stopped \
  docker.io/wolfyuan/dolphin:node
```
---

Command breakdown:
`-e GIT_URL="https://domain.com"` - Environment variables for controlling container, see [here](#🌎️-environment-variables-and-workflow) for a full list

> You can add multiple variables, like:
>
> `-e GIT_URL="https://domain.com" -e SYSTEM_PACKAGES="automake"`
>
> So the whole command will be
>  ```bash
> docker run --name dolphin-box -d \
>   -e GIT_URL="https://domain.com" \
>   -e SYSTEM_PACKAGES="automake" \
>   --restart unless-stopped \
>   docker.io/wolfyuan/dolphin:node
> ```

`--restart unless-stopped` - Restart your container when it fails or you reboot your machine unless you stop it by yourself

`docker.io/wolfyuan/dolphin:node` - Container image, where `node` represents to image that's designed for this language, see [here](#📦️-container-images) for full list

## 📦️ Container images

> Most image supports `arm` based CPU unless mentioned in the note.

| Image name |                       Description                      |      Variants      |   Tag  |                 Architecture                 |
| :--------: | :----------------------------------------------------: | :----------------: | :----: | :------------------------------------------: |
|   Node.js  |  Image with necessary software to run Node.js software | `alpine`, `ubuntu` | `node` | `amd64`, `arm64 (ubuntu)`, `arm/v7 (ubuntu)` |
|    Base    | Base image, you should NOT use this image when running | `alpine`, `ubuntu` | `base` |           `amd64`, `arm64`,`arm/v7`          |

### Tagging format

Images are tagged with this format: `[Image Tag]-[Image Variants]`

For example, the `node` image with `ubuntu` base will be: `node-ubuntu`

If you don't specify image variants, it will pull the `ubuntu` base

For example, pulling the `node` tag will pull the `node-ubuntu` image

## 🌎️ Environment variables and workflow

### Applies to every image:

Environment variables:


| Environment variables name |                        Description                       |
| :------------------------: | :------------------------------------------------------: |
|      `SYSTEM_PACKAGES`     | Additional packages to install when the container starts |
|          `GIT_URL`         |        Git repo to clone when the container starts       |

Workflow:

1. Container starts
2. Prepare runner folders
3. Add additional system packages
4. Clone git repo with `GIT_URL`

| 📝 Note                                                                                                     |
| ----------------------------------------------------------------------------------------------------------- |
| You can install additional system packages via the `SYSTEM_PACKAGES` variable                               |
| For example, installing `automake` on the base system, just set `SYSTEM_PACKAGES` with the value `automake` |
| When installing multiple system packages, separate them by spaces, for example, `automake cmake`            |
| Alpine-based image will use `apk` to install packages                                                       |
| Ubuntu-based image will use `apt-get` to install packages                                                   |

### Image-specific options

<details>
<summary>node</summary>

Environment variables:

| Environment variables name |                        Description                        |
|:--------------------------:|:---------------------------------------------------------:|
|       `NODE_VERSION`       |       Node.js version to install, overrides `.nvmrc`      |
|     `NODE_START_SCRIPT`    | Script to run when container finished running init script |

Workflow:

1. Container start
2. [Base image initialize](#applies-to-every-image)
3. Install Node.js via `NODE_VERSION` or `.nvmrc` in your project
4. Install npm packages via the detected package manager
5. Run build script via detected package manager if presents
6. Start the Node.js process via `NODE_START_SCRIPT` or script in `package.json` via the detected package manager

| 📝 Note                                           |
| ------------------------------------------------- |
| Supported package managers: `pnpm`, `yarn`, `npm` |

| 📝 Note                                  |
|------------------------------------------|
| In package manager: `pnpm > yarn > npm`  |
| In node version: `NODE_VERSION > .nvmrc` |

</details>

<details>
<summary>python</summary>

Environment variables:

| Environment variables name |                        Description                        |
| :------------------------: | :-------------------------------------------------------: |
|      `PYTHON_VERSION`      |   Python version to install, overrides `.python-version`  |
|    `PYTHON_BUILD_SCRIPT`   |       Script to run after installing Python packages      |
|    `PYTHON_START_SCRIPT`   | Script to run when container finished running init script |
|     `PYTHON_START_FILE`    | Script to run when container finished running init script |

Workflow:

1. Container start
2. [Base image initialize](#applies-to-every-image)
3. Install Python via `PYTHON_VERSION` or `.python-version` in your project
4. Install python packages via `pip`
5. Start the Python process via `PYTHON_START_SCRIPT` and the script in `PYTHON_START_FILE` with command `python3`

| ⚠️ Warning                                                                                                                                                                          |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Due to how `pyenv` switch Python version, it's recommended to presist your container storage, see [Presist data inside container](#💾-persist-data-inside-container) for more info |

| 📝 Note                                                                                                                                                                 |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| When `PYTHON_START_SCRIPT` and `PYTHON_START_FILE` both exists, it will run `PYTHON_START_SCRIPT` first, and run `PYTHON_START_FILE` after previous script has finished |

| 📝 Note                                               |
| ----------------------------------------------------- |
| In Python version: `PYTHON_VERSION > .python-version` |


</details>

## 💾 Persist data inside container

You can mount two types of directory to the Dolphin container:
- `/home/dolphin`: Contain your code (space), and other runtime binaries installation like `nvm`, `pyenv`
  > Use this when you want to save more bandwidth
- `/home/dolphin/space`
  > Use this when you want to prevent rebuilding your project

To mount the directory, append these arguments when starting the Docker container:

```bash
-v /path/to/your/host/folder:/home/dolphin
```
or
```bash
-v /path/to/your/host/folder:/home/dolphin/space
```

| ⚠️ Warning                                         |
| ------------------------------------------------- |
| You can't mount two directories at the same time! |

## 🎩 RedHat Podman support

*It SHOULD work, maybe*

## 📽️ Graphics card support

I haven't tried it, but your application will be run in a rootless environment, so it might not work.
