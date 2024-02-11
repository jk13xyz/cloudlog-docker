FROM php:8.2-apache        
ARG VERSION=2.6.3                                                                                              
RUN touch /usr/local/etc/php/conf.d/uploads.ini \                                                                                                           
    && echo "file_uploads = On" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "memory_limit = 64M" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "upload_max_filesize = 64M" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "post_max_size = 64M" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "max_execution_time = 60" >> /usr/local/etc/php/conf.d/uploads.ini
RUN apt-get update \
    && apt-get install -y \
    git \
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
RUN touch /etc/crontab && \
    echo "3 */12 * * * curl --silent http://localhost/clublog/upload &>/dev/null" >> /etc/crontab && \
    echo "6 */12 * * * curl --silent http://localhost/qrz/upload &>/dev/null" >> /etc/crontab && \
    echo "9 */12 * * * curl --silent http://localhost/eqsl/sync &>/dev/null" >> /etc/crontab && \
    echo "12 */12 * * * curl --silent http://localhost/hrdlog/upload &>/dev/null" >> /etc/crontab && \    
    echo "15 */12 * * * curl --silent http://localhost/qrz/download &>/dev/null" >> /etc/crontab && \
    echo "0 1 * * 1 curl --silent http://localhost/update/lotw_users &>/dev/null" >> /etc/crontab && \    
    echo "10 1 */1 * * curl --silent http://localhost/lotw/lotw_upload &>/dev/null" >> /etc/crontab && \ 
    echo "20 3 * * 1 curl --silent http://localhost/update/update_clublog_scp &>/dev/null" >> /etc/crontab && \
    echo "3 3 1 */3 *  curl --silent http://localhost/update/update_dok &>/dev/null" >> /etc/crontab && \
    echo "0 2 1 */1 * curl --silent http://localhost/update/update_sota &>/dev/null" >> /etc/crontab && \
    echo "10 2 1 */1 * curl --silent http://localhost/update/update_wwff &>/dev/null" >> /etc/crontab && \
    echo "20 2 1 */1 * curl --silent http://localhost/update/update_pota &>/dev/null" >> /etc/crontab
RUN chmod 0644 /etc/crontab
RUN crontab /etc/crontab
RUN mkdir -p /var/log/cron
RUN sed -i 's/^exec /service cron start\n\nexec /' /usr/local/bin/apache2-foreground 
HEALTHCHECK CMD wget -q --no-cache --spider localhost/user/login