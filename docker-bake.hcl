variable "GIT_SHA" {
  default = "1234567"
}

group "default" {
  targets = ["base-alpine", "base-ubuntu", "node-alpine", "node-ubuntu", "python-alpine", "python-ubuntu"]
}


target "base-alpine" {
  dockerfile = "./base/alpine.dockerfile"
  platforms = ["linux/amd64", "linux/arm64", "linux/arm/v7"]
  tags = [
    "docker.io/wolfyuan/dolphin:base-alpine",
    "docker.io/wolfyuan/dolphin:base-alpine-${GIT_SHA}",
    "registry.gitlab.com/wolf-yuan/dolphin:base-alpine"
  ]
}

target "base-ubuntu" {
  dockerfile = "./base/ubuntu.dockerfile"
  platforms = ["linux/amd64", "linux/arm64", "linux/arm/v7"]
  tags = [
    "docker.io/wolfyuan/dolphin:base",
    "docker.io/wolfyuan/dolphin:base-ubuntu",
    "docker.io/wolfyuan/dolphin:base-ubuntu-${GIT_SHA}",
    "registry.gitlab.com/wolf-yuan/dolphin:base",
    "registry.gitlab.com/wolf-yuan/dolphin:base-ubuntu"
  ]
}

target "node-alpine" {
  dockerfile = "./nodejs/alpine.dockerfile"
  platforms = ["linux/amd64", "linux/arm64", "linux/arm/v7"]
  contexts = {
    "wolfyuan/dolphin:base-alpine" = "target:base-alpine"
  }
  tags = [
    "docker.io/wolfyuan/dolphin:node-alpine",
    "docker.io/wolfyuan/dolphin:node-alpine-${GIT_SHA}",
    "registry.gitlab.com/wolf-yuan/dolphin:node-alpine"
  ]
}

target "node-ubuntu" {
  dockerfile = "./nodejs/ubuntu.dockerfile"
  platforms = ["linux/amd64", "linux/arm64", "linux/arm/v7"]
  contexts = {
    "wolfyuan/dolphin:base-ubuntu" = "target:base-ubuntu"
  }
  tags = [
    "docker.io/wolfyuan/dolphin:node",
    "docker.io/wolfyuan/dolphin:node-ubuntu",
    "docker.io/wolfyuan/dolphin:node-ubuntu-${GIT_SHA}",
    "registry.gitlab.com/wolf-yuan/dolphin:node",
    "registry.gitlab.com/wolf-yuan/dolphin:node-ubuntu"
  ]
}

target "python-alpine" {
  dockerfile = "./python/alpine.dockerfile"
  platforms = ["linux/amd64", "linux/arm64", "linux/arm/v7"]
  contexts = {
    "wolfyuan/dolphin:base-alpine" = "target:base-alpine"
  }
  tags = [
    "docker.io/wolfyuan/dolphin:python-alpine",
    "docker.io/wolfyuan/dolphin:python-alpine-${GIT_SHA}",
    "registry.gitlab.com/wolf-yuan/dolphin:python-alpine"
  ]
}

target "python-ubuntu" {
  dockerfile = "./python/ubuntu.dockerfile"
  platforms = ["linux/amd64", "linux/arm64", "linux/arm/v7"]
  contexts = {
    "wolfyuan/dolphin:base-ubuntu" = "target:base-ubuntu"
  }
  tags = [
    "docker.io/wolfyuan/dolphin:python",
    "docker.io/wolfyuan/dolphin:python-ubuntu",
    "docker.io/wolfyuan/dolphin:python-ubuntu-${GIT_SHA}",
    "registry.gitlab.com/wolf-yuan/dolphin:python",
    "registry.gitlab.com/wolf-yuan/dolphin:python-ubuntu"
  ]
}