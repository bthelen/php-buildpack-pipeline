#!/usr/bin/env bash

set -xe

#TODO - remove later
#Modify the packages installed on this container because the same task inside of
#binary-builder fails for some reason
apt-get update
apt-get -y upgrade
apt-get -y install libffi-dev libaspell-dev libc-client2007e-dev libexpat1-dev libgdbm-dev libgmp-dev libgpgme11-dev libjpeg-dev libldap2-dev libmcrypt-dev libpng-dev libpspell-dev libsasl2-dev libsnmp-dev libsqlite3-dev libtool libxml2-dev libzip-dev libzookeeper-mt-dev snmp-mibs-downloader automake libgeoip-dev libtidy-dev libenchant-dev firebird-dev librecode-dev freetds-dev libgearman-dev libsybdb5 libreadline-dev libedit-dev libssl-dev libcurl4-openssl-dev

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
wget https://raw.githubusercontent.com/cloudfoundry/buildpacks-ci/develop/tasks/build-binary-new/php-extensions.yml
./bin/binary-builder --name=php --version=$PHP_5_VERSION --md5=ae625e0cfcfdacea3e7a70a075e47155 --php-extensions-file=./php-extensions.yml
#Build a 7.1
wget https://raw.githubusercontent.com/cloudfoundry/buildpacks-ci/develop/tasks/build-binary-new/php7-extensions.yml
./bin/binary-builder --name=php7 --version=$PHP_7_VERSION --md5=32ea3ce54d7d5ed03c6c600dffd65813 --php-extensions-file=./php7-extensions.yml
popd

pushd binary-builder-source
cp *.tgz ../php-binaries-built/
popd

pushd php-binaries-built
sha256sum *
