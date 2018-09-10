#!/usr/bin/env bash

set -xe

pushd php-binaries-built
ln -s `pwd` /php-binaries
popd

pushd php-buildpack-source
#Will need to edit the manifest.yml
PHP_5_BINARY_LOCATION=/php-binaries/php-$PHP_5_VERSION-linux-x64.tgz
PHP_5_BINARY_SHA256=$(sha256sum $PHP_5_BINARY_LOCATION | awk '{print $1}')
cp ../php-pipeline-source/manifest.yml .
#PHP5 Section
sed -i s/--php-5-version--/$PHP_5_VERSION/g manifest.yml
sed -i  s/--php-5-binary-location--/$PHP_5_BINARY_SHA256/g manifest.yml
sed -i  s/--php-5-binary-sha--/$PHP_5_BINARY_SHA256/g manifest.yml
cat manifest.yml
#PHP7 Section
gem install bundler
BUNDLE_GEMFILE=cf.Gemfile bundle
BUNDLE_GEMFILE=cf.Gemfile bundle exec buildpack-packager --uncached --stack=cflinuxfs2

cp php_buildpack-cflinuxfs2-v$PHP_BUILDPACK_VERSION.zip ../php-buildpack-built/php_buildpack-cflinuxfs2-v$PHP_BUILDPACK_VERSION-$(date +%Y%m%d%H%M%S).zip