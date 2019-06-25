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

#get the version from the file
if [[ $PHP_VERSION = "71" ]]
then
    export PHP_VERSION_NUMBER=`cat php-71-version/php-71-version`
elif [[ $PHP_VERSION = "72" ]]
then
    export PHP_VERSION_NUMBER=`cat php-72-version/php-72-version`
elif [[ $PHP_VERSION = "73" ]]
then
    export PHP_VERSION_NUMBER=`cat php-73-version/php-73-version`
else
    exit 1
fi

pushd /binary-builder
#Run the builder - for some reason the md5sum is required but not used
cp ../php-pipeline-source/$EXTENSIONS_FILE .
./bin/binary-builder --name=php7 --version=$PHP_VERSION_NUMBER --md5=irrelevant --php-extensions-file=./$EXTENSIONS_FILE

popd

pushd binary-builder-source
cp *.tgz ../php-binaries-built/
popd
