#!/bin/bash -e
. /usr/local/share/chruby/chruby.sh && chruby 2.5.0
make build
make test
