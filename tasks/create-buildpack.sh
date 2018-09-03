#!/usr/bin/env bash

set -xe

pwd

pushd php-buildpack-source
#Will need to edit the manifest.yml
gem install bundler
BUNDLE_GEMFILE=cf.Gemfile bundle
BUNDLE_GEMFILE=cf.Gemfile bundle exec buildpack-packager --uncached --stack=cflinuxfs2
