FROM debian:buster-slim
MAINTAINER Damien Debin <damien.debin@smartapps.fr>

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL en_US.UTF-8
ENV LANGUAGE en_US:en

RUN \
 apt-get update &&\
 apt-get -y --no-install-recommends install curl locales apt-utils &&\
 echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen &&\
 locale-gen en_US.UTF-8 &&\
 /usr/sbin/update-locale LANG=en_US.UTF-8 &&\
 echo "mysql-server mysql-server/root_password password root" | debconf-set-selections &&\
 echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections &&\
 apt-get -y --no-install-recommends install ca-certificates gnupg git subversion imagemagick openssh-client curl software-properties-common gettext zip unzip default-mysql-server default-mysql-client apt-transport-https ruby python python3 perl memcached geoip-database make ffmpeg shellcheck &&\
 curl -sSL https://packages.sury.org/php/apt.gpg | apt-key add - &&\
 echo "deb https://packages.sury.org/php/ buster main" | tee /etc/apt/sources.list.d/deb.sury.org.list &&\
 apt-get update &&\
 apt-get -y --no-install-recommends install \
  php-apcu php-geoip php-imagick php-memcache php-memcached php-pcov php-xdebug \
  php7.3-bcmath php7.3-cli php7.3-curl php7.3-gd php7.3-gettext php7.3-intl php7.3-json php7.3-mbstring php7.3-mysql php7.3-sqlite3 php7.3-xml php7.3-xmlrpc php7.3-zip \
  php7.2-bcmath php7.2-cli php7.2-curl php7.2-gd php7.2-gettext php7.2-intl php7.2-json php7.2-mbstring php7.2-mysql php7.2-sqlite3 php7.2-xml php7.2-xmlrpc php7.2-zip &&\
 apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* /var/log/*

RUN \
 update-alternatives --set php /usr/bin/php7.3 &&\
 sed -ri -e "s/^variables_order.*/variables_order=\"EGPCS\"/g" /etc/php/7.3/cli/php.ini &&\
 echo "\nmemory_limit=-1" >> /etc/php/7.3/cli/php.ini &&\
 echo "xdebug.max_nesting_level=250" >> /etc/php/7.3/mods-available/xdebug.ini &&\
 sed -ri -e "s/^variables_order.*/variables_order=\"EGPCS\"/g" /etc/php/7.2/cli/php.ini &&\
 echo "\nmemory_limit=-1" >> /etc/php/7.2/cli/php.ini &&\
 echo "xdebug.max_nesting_level=250" >> /etc/php/7.2/mods-available/xdebug.ini

RUN \
 curl -sSL https://getcomposer.org/installer | php -- --filename=composer --install-dir=/usr/bin &&\
 curl -sSL https://phar.phpunit.de/phpunit.phar -o /usr/bin/phpunit  && chmod +x /usr/bin/phpunit &&\
 curl -sSL https://codeception.com/codecept.phar -o /usr/bin/codecept && chmod +x /usr/bin/codecept &&\
 curl -sSL https://github.com/infection/infection/releases/download/0.14.2/infection.phar -o /usr/bin/infection && chmod +x /usr/bin/infection &&\
 curl -sSL https://git.io/n-install | bash -s -- -y &&\
 /root/n/bin/n 10 &&\
 npm install --no-color --production --global yarn &&\
 rm -rf /root/.npm /tmp/* /var/tmp/* /var/lib/apt/lists/* /var/log/*
