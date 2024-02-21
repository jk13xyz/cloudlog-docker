FROM php:8.2-apache        
ARG VERSION=2.6.5                                                                                              
RUN touch /usr/local/etc/php/conf.d/uploads.ini && \                                                                                                           
    echo "file_uploads = On" >> /usr/local/etc/php/conf.d/uploads.ini && \
    echo "memory_limit = 64M" >> /usr/local/etc/php/conf.d/uploads.ini && \
    echo "upload_max_filesize = 64M" >> /usr/local/etc/php/conf.d/uploads.ini && \
    echo "post_max_size = 64M" >> /usr/local/etc/php/conf.d/uploads.ini && \
    echo "max_execution_time = 120" >> /usr/local/etc/php/conf.d/uploads.ini
RUN apt-get update && \
    apt-get install -y \
    curl \
    cron \
    libxml2-dev \
    libonig-dev \
    wget
RUN docker-php-ext-install \
    mysqli \
    mbstring \
    xml
RUN a2enmod rewrite    
RUN cd /var/www/html && rm -rf *
WORKDIR /var/www/html
RUN wget https://github.com/magicbug/Cloudlog/archive/refs/tags/${VERSION}.tar.gz && \
    tar -xf ${VERSION}.tar.gz && \
    mv /var/www/html/Cloudlog-${VERSION}/* /var/www/html/ && \
    rm -rf Cloudlog-${VERSION} && \
    rm ${VERSION}.tar.gz
RUN chown -R www-data:www-data /var/www/html
RUN sed -i "s/\$config\['index_page'\] = 'index.php';/\$config\['index_page'\] = '';/g" ./install/config/config.php
COPY misc/.htaccess /var/www/html/
RUN sed -i "s/define('ENVIRONMENT', 'development');/define('ENVIRONMENT', 'production');/" ./index.php
RUN chmod -R g+rw ./application/config/ \
    && chmod -R g+rw ./application/logs/ \
    && chmod -R g+rw ./assets/qslcard/ \
    && chmod -R g+rw ./backup/ \
    && chmod -R g+rw ./updates/ \
    && chmod -R g+rw ./uploads/ \
    && chmod -R g+rw ./images/eqsl_card_images/ \
    && chmod -R g+rw ./assets/json/ \
    && chmod -R 777 /var/www/html/install
COPY misc/cronjob_backup.sh /var/www/html/
RUN chmod g+rwx ./cronjob_backup.sh && \
    chmod +x ./cronjob_backup.sh
COPY misc/crontab /etc/crontab
RUN mkdir /var/www/html/crontab
COPY misc/crontab /var/www/html/crontab
RUN chmod 0644 /etc/crontab
RUN sed -i 's/^exec /service cron start\n\nexec /' /usr/local/bin/apache2-foreground 
HEALTHCHECK CMD wget -q --no-cache --spider localhost/user/login