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
#Build a 7.1
cp ../php-pipeline-source/php71-extensions.yml .
./bin/binary-builder --name=php7 --version=$PHP_7_1_VERSION --md5=32ea3ce54d7d5ed03c6c600dffd65813 --php-extensions-file=./php71-extensions.yml

#Build a 7.2
cp ../php-pipeline-source/php72-extensions.yml .
./bin/binary-builder --name=php7 --version=$PHP_7_2_VERSION --md5=32ea3ce54d7d5ed03c6c600dffd65813 --php-extensions-file=./php72-extensions.yml

#Build a 7.3
cp ../php-pipeline-source/php73-extensions.yml .
./bin/binary-builder --name=php7 --version=$PHP_7_3_VERSION --md5=32ea3ce54d7d5ed03c6c600dffd65813 --php-extensions-file=./php73-extensions.yml

popd

pushd binary-builder-source
cp *.tgz ../php-binaries-built/
popd

pushd php-binaries-built
zip php_binaries-v$(date +%Y%m%d%H%M%S).zip *.tgz
sha256sum *
