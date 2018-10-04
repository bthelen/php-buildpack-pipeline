#!/usr/bin/env bash

set -xe

pushd php-binaries-built
ln -s `pwd` /php-binaries
popd

pushd php-buildpack-source
#Try to turn on the alias http module
sed -i s/'#LoadModule alias_module modules\/mod_alias.so'/'LoadModule alias_module modules\/mod_alias.so'/g defaults/config/httpd/extra/httpd-modules.conf
#Add Configuration to httpd.conf to set the directory
echo '
<Directory "${HOME}/app">
    Options SymLinksIfOwnerMatch
    AllowOverride All
    Require all granted
</Directory>' >> defaults/config/httpd/httpd.conf
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
PHP_7_BINARY_LOCATION_ESCAPED="\/php-binaries\/php7-$PHP_7_VERSION-linux-x64.tgz"
PHP_7_BINARY_LOCATION="/php-binaries/php7-$PHP_7_VERSION-linux-x64.tgz"
PHP_7_BINARY_SHA256=$(sha256sum $PHP_7_BINARY_LOCATION | awk '{print $1}')
sed -i s/'##php-7-version##'/$PHP_7_VERSION/g manifest.yml
sed -i s/'##php-7-binary-location##'/$PHP_7_BINARY_LOCATION_ESCAPED/g manifest.yml
sed -i s/'##php-7-binary-sha##'/$PHP_7_BINARY_SHA256/g manifest.yml
cat manifest.yml
gem install bundler
BUNDLE_GEMFILE=cf.Gemfile bundle
BUNDLE_GEMFILE=cf.Gemfile bundle exec buildpack-packager --cached --stack=cflinuxfs2
cp php_buildpack*.zip ../php-buildpack-built/
popd

pushd php-buildpack-built
rename "s/.zip$/-$(date +%Y%m%d%H%M%S).zip/" *.zip
ls
popd