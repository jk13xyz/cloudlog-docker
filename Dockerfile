FROM php:8.2-apache        
ARG VERSION=2.7.2
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
RUN touch /etc/crontab && \
    echo "0 */12 * * * curl --silent http://localhost/clublog/upload > /dev/stdout 2>&1" >> /etc/crontab && \
    echo "10 */12 * * * curl --silent http://localhost/eqsl/sync > /dev/stdout 2>&1" >> /etc/crontab && \    
    echo "20 */12 * * * curl --silent http://localhost/qrz/upload > /dev/stdout 2>&1" >> /etc/crontab && \
    echo "30 */12 * * * curl --silent http://localhost/qrz/download > /dev/stdout 2>&1" >> /etc/crontab && \        
    echo "40 */12 * * * curl --silent http://localhost/hrdlog/upload > /dev/stdout 2>&1" >> /etc/crontab && \
    echo "0 1 * * * curl --silent http://localhost/lotw/lotw_upload > /dev/stdout 2>&1" >> /etc/crontab && \     
    echo "10 1 * * * curl --silent http://localhost/update/lotw_users > /dev/stdout 2>&1" >> /etc/crontab && \
    echo "20 1 * * 1 curl --silent http://localhost/update/update_clublog_scp > /dev/stdout 2>&1" >> /etc/crontab && \
    echo "0 2 1 */1 * curl --silent http://localhost/update/update_sota > /dev/stdout 2>&1" >> /etc/crontab && \
    echo "10 2 1 */1 * curl --silent http://localhost/update/update_wwff > /dev/stdout 2>&1" >> /etc/crontab && \
    echo "20 2 1 */1 * curl --silent http://localhost/update/update_pota > /dev/stdout 2>&1" >> /etc/crontab && \
    echo "0 3 1 */1 *  curl --silent http://localhost/update/update_dok > /dev/stdout 2>&1" >> /etc/crontab    
RUN chmod 0644 /etc/crontab
RUN crontab /etc/crontab
RUN sed -i 's/^exec /service cron start\n\nexec /' /usr/local/bin/apache2-foreground 
HEALTHCHECK CMD wget -q --no-cache --spider localhost/user/login
