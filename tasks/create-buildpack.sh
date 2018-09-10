#!/usr/bin/env bash

set -xe

pushd php-binaries-built
ln -s `pwd` /php-binaries
popd

pushd php-buildpack-source
#Will need to edit the manifest.yml
cp ../php-pipeline-source/manifest.yml .
gem install bundler
BUNDLE_GEMFILE=cf.Gemfile bundle
BUNDLE_GEMFILE=cf.Gemfile bundle exec buildpack-packager --uncached --stack=cflinuxfs2

cp php_buildpack-cflinuxfs2-v$PHP_BUILDPACK_VERSION.zip ../php-buildpack-built/php_buildpack-cflinuxfs2-v$PHP_BUILDPACK_VERSION-$(date +%Y%m%d%H%M%S).zip