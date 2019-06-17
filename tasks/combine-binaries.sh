#!/usr/bin/env bash

set -xe

find php-binaries-built

pushd php-binaries-built
zip php_binaries-v$(date +%Y%m%d%H%M%S).zip *.tgz
sha256sum *
