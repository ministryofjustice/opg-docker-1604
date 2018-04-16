#!/bin/bash +x

build() {
  make build
}

test() {
  make test
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

  TAG=$(read_tag)
  echo "\nTag: ${TAG:?}"
  push_image "${1:?}" "${TAG:?}"
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
