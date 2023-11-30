# 🐬 Dolphin
## All in one solution for hosting your code

> Dolphin is still under heavy development, please create a issue if you face any bugs or request a feature

Dolphin is a cool container image that prepared everything for you!

✨ Features:
- Container running with `s6-overlay`
- Modular design
- Support wide vairity of language
- Multi base image and CPU architecture
- Code runs in rootless process

## 🏃 Running image

```bash
docker run --name dolphin-box -d \
  -e GIT_URL="https://domain.com" \
  --restart unless-stopped \
  docker.io/wolfyuan/dolphin:node
```
---

Command breakdown:
`-e GIT_URL="https://domain.com"` - Environment variables for controlling container, see [here](#🌎️-environment-variables-and-workflow) for full list
`--restart unless-stopped` - Restart your container when it fail or you rebooted your machine, unless you stop it by yourself
`docker.io/wolfyuan/dolphin:node` - Container image, where `node` represents to image that's designed for this language, see [here](#📦️-container-images) for full list

## 📦️ Container images

> Most image supports `arm` based CPU unless mentioned in note.

| Image name |                       Description                      |      Variants      |   Tag  |                     Note                    |
|:----------:|:------------------------------------------------------:|:------------------:|:------:|:-------------------------------------------:|
|   Node.js  |  Image with necessary software to run Node.js software | `alpine`, `ubuntu` | `node` | `alpine` does not support `arm64`, `armv7l` |
|    Base    | Base image, you should NOT use this image when running | `alpine`, `ubuntu` | `base` |                      -                      |

### Tagging format

Images are tagged with this format: `[Image Tag]-[Image Variants]`
For example, `node` image with `ubuntu` base will be: `node-ubuntu`

## 🌎️ Environment variables and workflow

### Applies to every image:

Environment variables:

| Environment variables name |               Description               |
|:--------------------------:|:---------------------------------------:|
|          `GIT_URL`         | Git repo to clone when container starts |

Workflow:

```mermaid
flowchart LR
    A[Container start] -->|GIT_URL exists| B(Clone GIT_URL)
    A[Container start] -->|GIT_URL not exists| D(Extended image script)
    B --> D(Extended image script)
```

### Image specific options

<details>
<summary>node</summary>

Environment variables:

| Environment variables name |                        Description                        |
|:--------------------------:|:---------------------------------------------------------:|
|       `NODE_VERSION`       |       Node.js version to install, overrides `.nvmrc`      |
|     `NODE_START_SCRIPT`    | Script to run when container finished running init script |

Workflow:

```mermaid
flowchart TB
    A[Extended image script] --> B(Install nvm)
    B --> C(Install node.js)
    C -->|.nvmrc or NODE_VERSION exists| D(Install Node.js with version in .nvmrc or NODE_VERSION)
    C -->|.nvmrc not found| E(Install Node.js LTS)
    D --> F(Install package)
    E --> F(Install package)
    F -->|pnpm-lock.yaml exists| G(Use pnpm to install packages)
    F -->|yarn.lock exists| H(Use yarn to install packages)
    F -->|package-lock.json exists| I(Use npm to install packages)
    F -->|non of them were found| G(Use pnpm to install packages)
    G -->|build script found in package.json| J(Run build script)
    H -->|build script found in package.json| J(Run build script)
    I -->|build script found in package.json| J(Run build script)
    G --> K(Run start script)
    H --> K(Run start script)
    I --> K(Run start script)
    J -->|start script found in package.json| K(Run start script)
    J --> L(Run NODE_START_SCRIPT)
```

> Diagram is a *little* bit complex

| 📝 Note                                  |
|------------------------------------------|
| In package manager: `pnpm > yarn > npm`  |
| In node version: `NODE_VERSION > .nvmrc` |

</details>

## 💾 Persist data inside container

You can mount two type of directory to Dolphin container:
- `/home/dolphin`: Contain your code (space), and other runtime binaries installation like `nvm`, `pyenv`
  > Use this when you want to save more bandwidth
- `/home/dolphin/space`
  > Use this when you want to prevent rebuilding your project

To mount directory, append this arguments when starting Docker container:

```bash
-v /path/to/your/host/folder:/home/dolphin
```
or
```bash
-v /path/to/your/host/folder:/home/dolphin/space
```

| ⚠️ Warning                                       |
|-------------------------------------------------|
| You can't mount two directory at the same time! |

## 🎩 RedHat Podman support

*It SHOULD work, maybe*

## 📽️ Graphics card support

I haven't tried it, but your application will be ran in rootless environment, it might not work.
