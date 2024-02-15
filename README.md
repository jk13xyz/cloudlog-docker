# jk13xyz/cloudlog

This is an unofficial Docker for [Cloudlog](https://github.com/magicbug/Cloudlog), a PHP based amateur radio logging software created by 2M0SQL.

## Config

- Based on php:8.2-apache,
- mod_rewrite enabled,
- No "/index.php/" in the URL,
- "Production" mode enabled by default,
- Comes with Cronjobs preconfigured.

## Usage

**IMPORTANT: MAKE SURE TO CHANGE THE MYSQL PASSWORD!**

### Docker Compose

    ```

    version: '3'
        services:
        cloudlog-main:
            image: jk13xyz/cloudlog:latest
            container_name: cloudlog-main
            depends_on:
            - cloudlog-mysql
            volumes:
            - cloudlog-config:/var/www/html/application/config
            - cloudlog-backup:/var/www/html/application/backup
            - cloudlog-uploads:/var/www/html/application/uploads
            ports:
            - "7373:80"
            restart: unless-stopped  
            
        cloudlog-mysql:
            image: mysql:latest
            container_name: cloudlog-mysql
            environment:
            MYSQL_RANDOM_ROOT_PASSWORD: yes
            MYSQL_DATABASE: cloudlog
            MYSQL_USER: cloudlog
            MYSQL_PASSWORD: "STRONG_PASSWORD"
            volumes:
            - cloudlog-dbdata:/var/lib/mysql
            restart: unless-stopped

        cloudlog-phpmyadmin:
            image: phpmyadmin:latest
            container_name: cloudlog-phpmyadmin
            depends_on:
            - cloudlog-mysql
            environment:
            PMA_HOST: cloudlog-mysql
            PMA_PORT: 3306
            PMA_USER: cloudlog
            PMA_PASSWORD: "STRONG_PASSWORD"
            restart: unless-stopped
            ports:
            - "7374:80" 

        volumes:
        cloudlog-dbdata:
        cloudlog-config:
        cloudlog-backup:
        cloudlog-uploads:

    ```

### Docker Run

    ```

        docker volume create cloudlog-dbdata && \
        docker volume create cloudlog-config && \
        docker volume create cloudlog-backup && \
        docker volume create cloudlog-uploads
    
        docker run -d \
            --name cloudlog-main \
            -v cloudlog-config:/var/www/html/application/config \
            -v cloudlog-backup:/var/www/html/application/backup \
            -v cloudlog-uploads:/var/www/html/application/uploads \
            -p 7373:80 \
            --restart unless-stopped \
            jk13xyz/cloudlog:latest

        docker run -d \
            --name cloudlog-mysql \
            -e MYSQL_RANDOM_ROOT_PASSWORD=yes \
            -e MYSQL_DATABASE=cloudlog \
            -e MYSQL_USER=cloudlog \
            -e MYSQL_PASSWORD="STRONG_PASSWORD" \
            -v cloudlog-dbdata:/var/lib/mysql \
            --restart unless-stopped \
            mysql:latest

        docker run -d \
            --name cloudlog-phpmyadmin \
            -e PMA_HOST=cloudlog-mysql \
            -e PMA_PORT=3306 \
            -e PMA_USER=cloudlog \
            -e PMA_PASSWORD="STRONG_PASSWORD" \
            --restart unless-stopped \
            -p 7374:80 \
            phpmyadmin:latest
    ```

## Install

1. Open Cloudlog on your host (e.g. localhost:7373).
2. Change the Locator and adjust the URL, if necessary. You can leave "Directory" usually empty.
3. Enter the database credentials

    - Host: cloudlog-mysql
    - User: cloudlod
    - Database: cloudlog

    Use the password you choose when running the docker.

4. Hit install.

    - If Cloudlog installs into a blank screen, open the base URL

## Cronjobs

All cronjobs are set by the Dockerfile. They don't need to be manually enabled. They also cannot be changed manually. I use these settings because they made the most sense to me. The spacing is done to ensure the scripts don't run concurrently and cause time-outs.

The set cronjobs and runtimes are:

### ClubLog upload

Every day at 00:00 and 12:00

### QRZ upload

Every day at 00:10 and 12:10

### QRZ download

Every day at 00:20 and 12:20

### eQSL sync

Every day at 00:30 and 12:30

### HRDLog upload

Every day at 00:40 and 12:40

### LotW upload

Every day at 01:00

### LotW user database update

Every day at 01:10

### ClubLog Super Check Partial

Every Monday at 01:20

### Summits on the Air (SOTA) database update

On the 1st of every month at 02:00

### World Wide Flora & Fauna (WWFF) databse update

On the 1st of every month at 02:10

### Parks on the Air (POTA) database update

On the 1st of every month at 02:20

### DOK database update

Every 6 months on the 1st at 03:00

## Support

Please note, this is primarily for my own setup. I made it because it offers support out of the box for things other images don't.

Feel free to use it (it should work fine). If you find issues, report them on my [Github](https://github.com/jk13xyz/cloudlog-docker/issues). However, I don't guarantee any support.

## Source

- This Docker:

    [jk13xyz/cloudlog-docker](https://github.com/jk13xyz/cloudlog-docker)

- Cloudlog:

    [magicbug/cloudlog](https://github.com/magicbug/cloudlog)
