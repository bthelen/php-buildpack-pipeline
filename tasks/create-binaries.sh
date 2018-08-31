#!/usr/bin/env bash

set -xe

find .

# extract oracle drivers and sym link
pushd oracle-drivers
tar zxvf oracle*tar.gz
ln -s . /oracle
popd

#change to the binary builder directory and build php binaries
pushd binary-builder-source
wget https://raw.githubusercontent.com/cloudfoundry/public-buildpacks-ci-robots/master/binary-builds/php7-extensions.yml
./bin/binary-builder --name=php7 --version=7.0.9 --md5=32ea3ce54d7d5ed03c6c600dffd65813  --php-extensions-file=./php7-extensions.yml
tar ztvf *.tgz
popd
