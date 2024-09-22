apt update
apt -y upgrade

RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata

apt install -y unzip
apt install -y php libapache2-mod-php

cd /app

export COMPOSER_HOME=/app/composer
export COMPOSER_VENDOR_HOME=$COMPOSER_HOME/vendor

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
mv  composer.phar  /usr/local/bin/composer

composer global require "laravel/installer"


export PATH=/app/composer/vendor/bin:$PATH
