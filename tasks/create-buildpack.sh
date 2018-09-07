#!/usr/bin/env bash

set -xe

pwd

pushd php-binaries-built
ln -s `pwd` /php-binaries
popd

pushd php-buildpack-source
#Will need to edit the manifest.yml
gem install bundler
BUNDLE_GEMFILE=cf.Gemfile bundle
BUNDLE_GEMFILE=cf.Gemfile bundle exec buildpack-packager --uncached --stack=cflinuxfs2

cp php_buildpack-cflinuxfs2-v4.3.60.zip ../php-buildpack-built/php_buildpack-cflinuxfs2-v4.3.60-$(date +%Y%m%d%H%M%S).zip