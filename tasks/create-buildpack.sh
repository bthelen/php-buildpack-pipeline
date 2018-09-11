#!/usr/bin/env bash

set -xe

pushd php-binaries-built
ln -s `pwd` /php-binaries
popd

pushd php-buildpack-source
#Get our custom version of manifest.yml
cp ../php-pipeline-source/manifest.yml .
#PHP5 Section
PHP_5_BINARY_LOCATION_ESCAPED="\/php-binaries\/php-$PHP_5_VERSION-linux-x64.tgz"
PHP_5_BINARY_LOCATION="/php-binaries/php-$PHP_5_VERSION-linux-x64.tgz"
PHP_5_BINARY_SHA256=$(sha256sum $PHP_5_BINARY_LOCATION | awk '{print $1}')
sed -i s/'##php-5-version##'/$PHP_5_VERSION/g manifest.yml
sed -i s/'##php-5-binary-location##'/$PHP_5_BINARY_LOCATION_ESCAPED/g manifest.yml
sed -i s/'##php-5-binary-sha##'/$PHP_5_BINARY_SHA256/g manifest.yml
#PHP7 Section
PHP_7_BINARY_LOCATION_ESCAPED="\/php-binaries\/php-$PHP_7_VERSION-linux-x64.tgz"
PHP_7_BINARY_LOCATION="/php-binaries/php-$PHP_7_VERSION-linux-x64.tgz"
PHP_7_BINARY_SHA256=$(sha256sum $PHP_7_BINARY_LOCATION | awk '{print $1}')
sed -i s/'##php-7-version##'/$PHP_7_VERSION/g manifest.yml
sed -i s/'##php-7-binary-location##'/$PHP_7_BINARY_LOCATION_ESCAPED/g manifest.yml
sed -i s/'##php-7-binary-sha##'/$PHP_7_BINARY_SHA256/g manifest.yml
cat manifest.yml
gem install bundler
BUNDLE_GEMFILE=cf.Gemfile bundle
BUNDLE_GEMFILE=cf.Gemfile bundle exec buildpack-packager --uncached --stack=cflinuxfs2

cp php_buildpack-cflinuxfs2-v$PHP_BUILDPACK_VERSION.zip ../php-buildpack-built/php_buildpack-cflinuxfs2-v$PHP_BUILDPACK_VERSION-$(date +%Y%m%d%H%M%S).zip