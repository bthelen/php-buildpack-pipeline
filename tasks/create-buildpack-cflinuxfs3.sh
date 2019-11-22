#!/usr/bin/env bash

set -xe

pushd php-71-binaries
ln -s `pwd` /php-71-binaries
popd

pushd php-73-binaries
ln -s `pwd` /php-73-binaries
popd

pushd php-buildpack-source
#Get our custom version of manifest.yml
cp ../php-pipeline-source/manifest.yml .

#PHP7.1 Section
PHP_7_1_VERSION=$(find /php-71-binaries/ -name "php7-*-linux-x64.tgz" | awk 'BEGIN { FS = "-" } ; { print $4 }')
PHP_7_1_BINARY_LOCATION_ESCAPED="\/php-71-binaries\/php7-$PHP_7_1_VERSION-linux-x64.tgz"
PHP_7_1_BINARY_LOCATION="/php-71-binaries/php7-$PHP_7_1_VERSION-linux-x64.tgz"
PHP_7_1_BINARY_SHA256=$(sha256sum $PHP_7_1_BINARY_LOCATION | awk '{print $1}')
sed -i s/'##php-7-1-version##'/$PHP_7_1_VERSION/g manifest.yml
sed -i s/'##php-7-1-binary-location##'/$PHP_7_1_BINARY_LOCATION_ESCAPED/g manifest.yml
sed -i s/'##php-7-1-binary-sha##'/$PHP_7_1_BINARY_SHA256/g manifest.yml

#PHP7.3 Section
PHP_7_3_VERSION=$(find /php-73-binaries/ -name "php7-*-linux-x64.tgz" | awk 'BEGIN { FS = "-" } ; { print $4 }')
PHP_7_3_BINARY_LOCATION_ESCAPED="\/php-73-binaries\/php7-$PHP_7_3_VERSION-linux-x64.tgz"
PHP_7_3_BINARY_LOCATION="/php-73-binaries/php7-$PHP_7_3_VERSION-linux-x64.tgz"
PHP_7_3_BINARY_SHA256=$(sha256sum $PHP_7_3_BINARY_LOCATION | awk '{print $1}')
sed -i s/'##php-7-3-version##'/$PHP_7_3_VERSION/g manifest.yml
sed -i s/'##php-7-3-binary-location##'/$PHP_7_3_BINARY_LOCATION_ESCAPED/g manifest.yml
sed -i s/'##php-7-3-binary-sha##'/$PHP_7_3_BINARY_SHA256/g manifest.yml

cat manifest.yml
gem install bundler -v '1.17.3'

BUNDLE_GEMFILE=cf.Gemfile bundle
BUNDLE_GEMFILE=cf.Gemfile bundle exec buildpack-packager --cached --stack=cflinuxfs3
cp php_buildpack*.zip ../php-buildpack-built/
popd

pushd php-buildpack-built
for file in php_buildpack*.zip; do mv "$file" "`echo $file | sed "s/.zip$/-$(date +%Y%m%d%H%M%S).zip/"`" ; done
ls
popd
