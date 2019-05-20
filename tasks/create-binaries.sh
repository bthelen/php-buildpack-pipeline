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
##Build a 5.6
#wget https://raw.githubusercontent.com/cloudfoundry/buildpacks-ci/develop/tasks/build-binary-new/php-extensions.yml
#./bin/binary-builder --name=php --version=$PHP_5_VERSION --md5=ae625e0cfcfdacea3e7a70a075e47155 --php-extensions-file=./php-extensions.yml

#Build a 7.1
wget https://raw.githubusercontent.com/cloudfoundry/buildpacks-ci/develop/tasks/build-binary-new/php71-extensions.yml
./bin/binary-builder --name=php7 --version=$PHP_7_1_VERSION --md5=32ea3ce54d7d5ed03c6c600dffd65813 --php-extensions-file=./php71-extensions.yml
popd

#Build a 7.2
wget https://raw.githubusercontent.com/cloudfoundry/buildpacks-ci/develop/tasks/build-binary-new/php72-extensions.yml
./bin/binary-builder --name=php7 --version=$PHP_7_2_VERSION --md5=32ea3ce54d7d5ed03c6c600dffd65813 --php-extensions-file=./php72-extensions.yml
popd

#Build a 7.3
wget https://raw.githubusercontent.com/cloudfoundry/buildpacks-ci/develop/tasks/build-binary-new/php73-extensions.yml
./bin/binary-builder --name=php7 --version=$PHP_7_3_VERSION --md5=32ea3ce54d7d5ed03c6c600dffd65813 --php-extensions-file=./php73-extensions.yml
popd

pushd binary-builder-source
cp *.tgz ../php-binaries-built/
popd

pushd php-binaries-built
zip php_binaries-v$(date +%Y%m%d%H%M%S).zip *.tgz
sha256sum *
