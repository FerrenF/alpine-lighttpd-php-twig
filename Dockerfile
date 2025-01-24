FROM ghcr.io/alastairhm/alpine-lighttpd:latest

# Install PHP and required extensions, including those for Twig and Composer
RUN apk --update add \
    php-common \
    php-iconv \
    php-json \
    php-gd \
    php-curl \
    php-xml \
    php-simplexml \
    php-pgsql \
    php-imap \
    php-cgi \
    fcgi \
    php-pdo \
    php-pdo_pgsql \
    php-soap \
    php-posix \
    php-gettext \
    php-ldap \
    php-ctype \
    php-dom \
    php-opcache \
    php-phar \
    php-mbstring \
    php-session \
    php-tokenizer \
    php-openssl \
    php-fileinfo \
    curl \
    unzip && \
    rm -rf /var/cache/apk/*

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add lighttpd configuration and set up runtime environment
ADD lighttpd.conf /etc/lighttpd/lighttpd.conf
RUN mkdir -p /run/lighttpd/ && \
    chown www-data: /run/lighttpd/

# Expose HTTP port and set up the web root volume
EXPOSE 80
VOLUME /var/www

# Run php-fpm and lighttpd
CMD php-fpm -D && lighttpd -D -f /etc/lighttpd/lighttpd.conf

# Install Twig via Composer
RUN composer require twig/twig
