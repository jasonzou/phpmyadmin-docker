FROM centos:centos6
MAINTAINER Alex Tomkins <alex@blanc.ltd.uk>

# Install Apache/PHP
RUN yum update -y
RUN yum install -y httpd php

# Install phpMyAdmin
RUN rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
RUN yum install -y phpMyAdmin
COPY phpMyAdmin/ /etc/phpMyAdmin/
RUN sed -i \
    -e 's/.*blowfish.*//g' \
    -e "s/'cookie'/'http'/g" \
    -e 's|?>|include "/etc/phpMyAdmin/extra.inc.php";|g' /etc/phpMyAdmin/config.inc.php

# Apache tweaking
RUN sed -i \
    -e 's/^Listen/#Listen/g' \
    -e's/^LoadModule/#LoadModule/g' \
    /etc/httpd/conf/httpd.conf
RUN rm /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/phpMyAdmin.conf
COPY conf.d/ /etc/httpd/conf.d/
COPY php.d/ /etc/php.d/

ADD phpmyadmin-run /usr/local/sbin/phpmyadmin-run
CMD ["phpmyadmin-run"]
