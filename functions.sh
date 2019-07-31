#!/bin/bash

build() {
  make build
}

test() {
  if grep test: Makefile;then
    make test
  else
    echo "No test target found"
  fi
}

tag() {
  local TAG

  if [[ "${BRANCH_NAME}" == "master" ]];then
    TAG=$( semvertag bump patch --tag )
  else
    TAG=$( semvertag bump patch --tag --stage "alpha" )
  fi
  echo $TAG > semvertag.txt
  cat semvertag.txt
}

read_tag() {
  local TAG

  if [[ -f semvertag.txt ]];then
    TAG=$(head -n 1 semvertag.txt)
  elif [[ -f ../semvertag.txt ]];then
    TAG=$(head -n 1 ../semvertag.txt)
  else
    echo "semvertag.txt not found"
  fi

  echo $TAG
}

# Use semver tag to get us a sensible git and docker tag
# The git tag needs to be prefixed with the project name so we can find it when
# running semvertag list --prefix
# @args
# $1 PROJECT
tag_and_push_image() {
  local PREFIX
  local TAG # e.g. 0.0.1-alpha
  local NAME=${1:?}

  TAG=$(read_tag)
  echo "Tag: ${TAG:?}"
  push_image "${NAME}" "${TAG:?}"
}

# Checks if we are in CI & pushes
# If we're not push echo a polite message
# This stops accidental pushing when testing locally
# @args
# $1 image name
# $2 image tag
docker_push() {
  local IMAGE_NAME="${1:?}"
  local TAG="${2:?}"
  if [[ $CI = "true" ]];then
    docker push "${IMAGE_NAME}:${TAG}"
    echo "Last exit status: $?"
  else
    echo "Not in CI so not pushing tag"
  fi
}

# Push to our Docker registry
# @args
# $1 PROJECT
# $2 TAG
push_image() {
  local REGISTRY
  local IMAGE_NAME=$1
  local TAG=$2
  REGISTRY="registry.service.opg.digital"
  echo "Pushing image PROJECT:${IMAGE_NAME} TAG:${TAG}"
  # We Docker always builds with a tag of latest
  docker tag "${REGISTRY:?}/${IMAGE_NAME}:latest" "${REGISTRY:?}/${IMAGE_NAME}:${TAG}"

  printf "\\n\\n--- Pushing Image to Docker Registry ---\\n"
  docker_push "${REGISTRY:?}/${IMAGE_NAME}" "${TAG}"

  if [[ "${BRANCH_NAME}" == "master" ]];then
    printf "\\n\\n--- On master branch so pushing latest tag ---\\n"
    docker_push "${REGISTRY:?}/${IMAGE_NAME}" "latest"
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
