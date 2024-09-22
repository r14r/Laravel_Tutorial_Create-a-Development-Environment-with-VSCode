# -------------------------------------------------------------------------------------------------
FROM ubuntu:latest AS builder

LABEL MAINTAINER="Ralph Göstenmeier"

ARG DEBIAN_FRONTEND=noninteractive

ARG USR_NAME=user
ARG USR_HOME=/home/${USR_NAME}
ARG USR_ID=10000

ARG GRP_NAME=work
ARG GRP_ID=10000

ARG COMPOSER_HOME=/home/.composer
ARG COMPOSER_VENDOR_HOME=$COMPOSER_HOME/vendor

# set environment variables
ENV TZ='Europe/Berlin'
RUN echo $TZ > /etc/timezone 

# -------------------------------------------------------------------------------------------------
# BASE
# -------------------------------------------------------------------------------------------------
FROM builder AS base

RUN    apt-get update
RUN    apt-get install --yes tzdata \
    && rm /etc/localtime \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && apt-get clean

RUN apt-get install --yes build-essential lsb-release curl sudo git vim
RUN apt-get install --yes software-properties-common

RUN apt-get install --yes unzip file

# -------------------------------------------------------------------------------------------------
# PHP
# -------------------------------------------------------------------------------------------------
FROM base AS with-php
RUN apt-get install -y php libapache2-mod-php
RUN apt-get install -y php-xml php-dom php-sqlite3


# -------------------------------------------------------------------------------------------------
# WITH-USER
# -------------------------------------------------------------------------------------------------
FROM with-php AS with-user

RUN groupadd ${GRP_NAME}                 --gid ${GRP_ID} 
RUN adduser  ${USR_NAME} --uid ${USR_ID} --gid ${GRP_ID} --home ${USR_HOME} --disabled-password --gecos User

RUN mkdir -p ${USR_HOME}/bin
RUN chown -R ${USR_NAME}:${GRP_NAME} ${USR_HOME}/bin

RUN echo '%work        ALL=(ALL)       NOPASSWD: ALL' >/etc/sudoers.d/${GRP_NAME}


# -------------------------------------------------------------------------------------------------
# PHP Composer
# -------------------------------------------------------------------------------------------------
ENV COMPOSER_HOME=${COMPOSER_HOME}
ENV COMPOSER_VENDOR_HOME=${COMPOSER_VENDOR_HOME}

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php
RUN mv  composer.phar  /usr/local/bin/composer
RUN rm  composer-setup.php

# RUN composer global require "laravel/installer"

# =================================================================================================
# USER
# =================================================================================================
FROM with-user AS final

USER user

VOLUME [ "/app" ]
WORKDIR /app

# PHP Composer ------------------------------------------------------------------------------------
RUN echo 'export PATH="$COMPOSER_VENDOR_HOME"/bin:$PATH\n'        >>${USR_HOME}/.bashrc
RUN echo 'export COMPOSER_HOME=/home/.composer\n'                 >>${USR_HOME}/.bashrc
RUN echo 'export COMPOSER_VENDOR_HOME=$COMPOSER_HOME/vendor\n'    >>${USR_HOME}/.bashrc

# -------------------------------------------------------------------------------------------------
# CLEANUP
# -------------------------------------------------------------------------------------------------
RUN    sudo apt-get update \
    && sudo apt-get upgrade --yes


CMD ["bash", "-l"]
