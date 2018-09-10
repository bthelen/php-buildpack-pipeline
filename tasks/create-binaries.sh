#!/usr/bin/env bash

set -xe

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
#Build a 5.6
wget https://raw.githubusercontent.com/cloudfoundry/public-buildpacks-ci-robots/master/binary-builds/php-extensions.yml
./bin/binary-builder --name=php --version=$PHP_5_VERSION --md5=ae625e0cfcfdacea3e7a70a075e47155 --php-extensions-file=./php-extensions.yml
#Build a 7.1
wget https://raw.githubusercontent.com/cloudfoundry/public-buildpacks-ci-robots/master/binary-builds/php7-extensions.yml
./bin/binary-builder --name=php7 --version=$PHP_7_VERSION --md5=32ea3ce54d7d5ed03c6c600dffd65813 --php-extensions-file=./php7-extensions.yml
popd

pushd binary-builder-source
cp *.tgz ../php-binaries-built/
popd

pushd php-binaries-built
sha256sum *
