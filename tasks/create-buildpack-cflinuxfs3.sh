#!/usr/bin/env bash

set -xe

pushd php-binaries
unzip php_binaries-v*.zip
ln -s `pwd` /php-binaries
popd

pushd php-buildpack-source
#Get our custom version of manifest.yml
cp ../php-pipeline-source/manifest.yml .

##PHP5 Section
#PHP_5_BINARY_LOCATION_ESCAPED="\/php-binaries\/php-$PHP_5_VERSION-linux-x64.tgz"
#PHP_5_BINARY_LOCATION="/php-binaries/php-$PHP_5_VERSION-linux-x64.tgz"
#PHP_5_BINARY_SHA256=$(sha256sum $PHP_5_BINARY_LOCATION | awk '{print $1}')
#sed -i s/'##php-5-version##'/$PHP_5_VERSION/g manifest.yml
#sed -i s/'##php-5-binary-location##'/$PHP_5_BINARY_LOCATION_ESCAPED/g manifest.yml
#sed -i s/'##php-5-binary-sha##'/$PHP_5_BINARY_SHA256/g manifest.yml

#PHP7.1 Section
PHP_7_1_BINARY_LOCATION_ESCAPED="\/php-binaries\/php7-$PHP_7_1_VERSION-linux-x64.tgz"
PHP_7_1_BINARY_LOCATION="/php-binaries/php7-$PHP_7_1_VERSION-linux-x64.tgz"
PHP_7_1_BINARY_SHA256=$(sha256sum $PHP_7_1_BINARY_LOCATION | awk '{print $1}')
sed -i s/'##php-7-1-version##'/$PHP_7_1_VERSION/g manifest.yml
sed -i s/'##php-7-1-binary-location##'/$PHP_7_1_BINARY_LOCATION_ESCAPED/g manifest.yml
sed -i s/'##php-7-1-binary-sha##'/$PHP_7_1_BINARY_SHA256/g manifest.yml

#PHP7.2 Section
PHP_7_2_BINARY_LOCATION_ESCAPED="\/php-binaries\/php7-$PHP_7_2_VERSION-linux-x64.tgz"
PHP_7_2_BINARY_LOCATION="/php-binaries/php7-$PHP_7_2_VERSION-linux-x64.tgz"
PHP_7_2_BINARY_SHA256=$(sha256sum $PHP_7_2_BINARY_LOCATION | awk '{print $1}')
sed -i s/'##php-7-2-version##'/$PHP_7_2_VERSION/g manifest.yml
sed -i s/'##php-7-2-binary-location##'/$PHP_7_2_BINARY_LOCATION_ESCAPED/g manifest.yml
sed -i s/'##php-7-2-binary-sha##'/$PHP_7_2_BINARY_SHA256/g manifest.yml

#PHP7.3 Section
PHP_7_3_BINARY_LOCATION_ESCAPED="\/php-binaries\/php7-$PHP_7_3_VERSION-linux-x64.tgz"
PHP_7_3_BINARY_LOCATION="/php-binaries/php7-$PHP_7_3_VERSION-linux-x64.tgz"
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
rename "s/.zip$/-$(date +%Y%m%d%H%M%S).zip/" *.zip
ls
popd
