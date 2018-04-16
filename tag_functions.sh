#!/bin/bash +x

build() {
  make build
}

test() {
  make test
}

# Use semver tag to get us a sensible git and docker tag
# The git tag needs to be prefixed with the project name so we can find it when
# running semvertag list --prefix
# @args
# $1 PROJECT
tag_and_push_image() {
  local PREFIX
  local GIT_TAG # e.g.opg-base-0.0.1-alpha
  local DOCKER_TAG # 0.0.1-alpha

  PREFIX=$(strip_1604 "${1:?}")

  if [[ "${BRANCH_NAME}" == "master" ]];then
    GIT_TAG=$( semvertag bump patch --prefix "${PREFIX:?}-" --tag )
  else
    GIT_TAG=$( semvertag bump patch --prefix "${PREFIX:?}-" --stage "alpha" )
  fi

  DOCKER_TAG=$( to_docker_tag "${GIT_TAG}" "${PREFIX:?}-" )
  echo "Docker tag: ${DOCKER_TAG}"
  echo "Git tag: ${GIT_TAG:?}"
  push_image "${1:?}" "${DOCKER_TAG:?}"
}

# Push to our Docker registry
# @args
# $1 PROJECT
# $2 TAG
push_image() {
  local REGISTRY
  REGISTRY="registry.service.opg.digital"
  echo "Pushing image PROJECT:$1 TAG:$2"
  # We Docker always builds with a tag of latest
  docker tag "${REGISTRY:?}/${1:?}:latest" "${REGISTRY:?}/${1:?}:${2:?}"

  printf "\\n\\n--- Pushing Image to Docker ---\\n"
  docker_push "${REGISTRY:?}/${1:?}" "${2:?}"

  if [[ "${BRANCH_NAME}" == "master" ]];then
    printf "\\n\\n--- On master branch so pushing latest tag ---\\n"
    docker_push "${REGISTRY:?}/${1:?}" "latest"
  fi
}

# Semvertag doesn't like a 0 in the prefix right now
# https://github.com/ministryofjustice/semvertag/issues/4
# So strip 1604 from the tag
# @args
# $1 string
strip_1604() {
  local STR
  STR=${1//-1604/}
  echo "${STR:?}"
}

# Remove a string within a given string (sed over variables)
# @args
# $1 Original string
# $2 String to remove
to_docker_tag() {
  local STR
  STR=${1//$2/}
  echo "$STR"
}

# Checks if we are in CI & pushes
# If we're not push echo a polite message
# This stops accidental pushing when testing locally
# @args
# $1 image name
# $2 image tag
docker_push() {
  if [[ $CI = "true" ]];then
    docker push "${1:?}:${2:?}"
    echo "Last exit status: $?"
  else
    echo "Not in CI so not pushing tag"
  fi
  }
