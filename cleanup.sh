#!/bin/bash +e
# Ignore errors, so we can always clean down docker-compose networks

for i in * ;do
  if [ -d "$i" ]; then
    cd "$i" && make clean
  fi
done
