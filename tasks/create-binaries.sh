#!/usr/bin/env bash

set -xe

export DEBIAN_FRONTEND=noninteractive
export STACK=cflinuxfs3

# extract oracle drivers and sym link
pushd oracle-drivers
pwd
tar zxvf oracle*tar.gz
ln -s `pwd` /oracle
find /oracle
popd

#change to the binary builder directory and build php binaries
pushd binary-builder-source
pwd
ln -s `pwd` /binary-builder
popd

pushd /binary-builder
#Run the builder
cp ../php-pipeline-source/$EXTENSIONS_FILE .
./bin/binary-builder --name=php7 --version=$PHP_VERSION --md5=$MD5_SUM --php-extensions-file=./$EXTENSIONS_FILE

popd

pushd binary-builder-source
cp *.tgz ../php-binaries-built/
popd

#pushd php-binaries-built
#zip php_binaries-v$(date +%Y%m%d%H%M%S).zip *.tgz
#sha256sum *
