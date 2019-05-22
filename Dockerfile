FROM ubuntu:16.04@sha256:cad5e101ab30bb7f7698b277dd49090f520fe063335643990ce8fbd15ff920ef as Base

COPY apt.sources.list /etc/apt/sources.list
RUN apt-get update && apt-get install -y apache2 mariadb-server php php-curl php-gd php-ldap php-mbstring php-mcrypt php-mysql php-xml php-zip php-cli php-json curl unzip libapache2-mod-php locales

ENV LANG="en_US.UTF8"
ENV MYSQL_ROOT_PASSWORD="123456"
RUN echo -e "LANG=\"en_US.UTF-8\"\nLANGUAGE=\"en_US:en\"" > /etc/default/locale && locale-gen en_US.UTF-8

FROM Base
LABEL ZENTAO_VERSION="11.5.stable"

ADD zentao.tar.gz /var/www/zentaopms
RUN  mkdir -p /app/zentaopms \
  && a2enmod rewrite \
  && rm -rf /etc/apache2/sites-enabled/000-default.conf /var/lib/mysql/* \
  && sed -i '1i ServerName 127.0.0.1' /etc/apache2/apache2.conf
COPY config/apache.conf /etc/apache2/sites-enabled/000-default.conf
COPY config/ioncube_loader_lin_7.0.so /usr/lib/php/20151012/ioncube_loader_lin_7.0.so
COPY config/00-ioncube.ini /etc/php/7.0/apache2/conf.d/
COPY config/00-ioncube.ini /etc/php/7.0/cli/conf.d/

VOLUME /app/zentaopms /var/lib/mysql
COPY docker-entrypoint.sh /app
ENTRYPOINT ["/app/docker-entrypoint.sh"]
