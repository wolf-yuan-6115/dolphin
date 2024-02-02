variable "GIT_SHA" {
  default = "1234567"
}

variable "BUILD_DATE" {
  default = "2024-01-01T00:00:00Z"
}

group "default" {
  targets = ["base-alpine", "base-ubuntu", "node-alpine", "node-ubuntu", "python-alpine", "python-ubuntu"]
}

function "getPlatforms" {
  params = []
  result = ["linux/amd64", "linux/arm64", "linux/arm/v7"]
}

function "generateTags" {
  params = [
    imageName,
    imageBase,
    isMain
  ]
  result = flatten([
    concat(
      [
        "docker.io/wolfyuan/dolphin:${imageName}-${imageBase}",
        "docker.io/wolfyuan/dolphin:${imageName}-${imageBase}-${GIT_SHA}",
        "registry.gitlab.com/wolf-yuan/dolphin:${imageName}-${imageBase}"
      ],
      isMain == "true" ? [
        "docker.io/wolfyuan/dolphin:${imageName}",
        "registry.gitlab.com/wolf-yuan/dolphin:${imageName}"
      ] : []
    )
  ])
}

target "_default" {
  platforms = getPlatforms()
  args = {
    BUILD_DATE = "${BUILD_DATE}"
  }
}

target "base-alpine" {
  inherits = ["_default"]
  dockerfile = "./base/alpine.dockerfile"
  tags = generateTags("base", "alpine", "false")
}

target "base-ubuntu" {
  inherits = ["_default"]
  dockerfile = "./base/ubuntu.dockerfile"
  tags = generateTags("base", "alpine", "true")
}

target "node-alpine" {
  inherits = ["_default"]
  dockerfile = "./nodejs/alpine.dockerfile"
  contexts = {
    "wolfyuan/dolphin:base-alpine" = "target:base-alpine"
  }
  tags = generateTags("node", "alpine", "false")
}

target "node-ubuntu" {
  inherits = ["_default"]
  dockerfile = "./nodejs/ubuntu.dockerfile"
  contexts = {
    "wolfyuan/dolphin:base-ubuntu" = "target:base-ubuntu"
  }
  tags = generateTags("node", "ubuntu", "true")
}

target "python-alpine" {
  inherits = ["_default"]
  dockerfile = "./python/alpine.dockerfile"
  contexts = {
    "wolfyuan/dolphin:base-alpine" = "target:base-alpine"
  }
  tags = generateTags("python", "alpine", "false")
}

target "python-ubuntu" {
  inherits = ["_default"]
  dockerfile = "./python/ubuntu.dockerfile"
  contexts = {
    "wolfyuan/dolphin:base-ubuntu" = "target:base-ubuntu"
  }
  tags = generateTags("python", "ubuntu", "true")
}
