# jk13xyz/cloudlog

This is an unofficial Docker image for [Cloudlog](https://github.com/magicbug/Cloudlog), a PHP based amateur radio logging software created by 2M0SQL.

I created it after the team behind Cloudlog decided to rescind any support for Docker and no longer updates the official image. The intent of this image is to also default certain features the official image never had, such as enabling mod_rewrite or cronjobs.

## Config

- Based on php:8.2-apache,
- mod_rewrite enabled,
- No "/index.php/" in the URL,
- "Production" mode enabled by default,
- Comes with (most) cronjobs out-of-the-box.

## Current version

2.6.4

**Please note: There's a little bug in the official release showing the version as 2.6.3.**

## Usage

**IMPORTANT: MAKE SURE TO CHANGE THE MYSQL PASSWORD!**

### Docker Compose

```yaml
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

```bash
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

All cronjobs are set by the Dockerfile. They don't need to be manually enabled. They can be updated, but this is a hassle. I use these settings because they made the most sense to me. The spacing is done to ensure the scripts don't run concurrently and cause time-outs.

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

### Automatic backup of the ADIF log and Notes

Automating the backup of the logbook as ADIF, as well as the notes, is something that cannot be accomplished by default. Unlike the aforementioned cronjobs, backups require authentication. If this is a functionality you want, you will have to install and setup Cloudlog first. I have provided a shell script in the container to setup the required cronjobs.

In order to make these backups work, you will need to create a read-only API key. For that, open your Cloudlog instance, mouse over your callsign, go down to "API Keys" and click on "Create a read-only key". This key handles the authentication required to call the backup script.

After you created the API key, run the following command in your Terminal shell of choice:

```bash
docker exec cloudlog-main /bin/sh -c './cronjob_backup.sh -K <YOUR API KEY>'
```

**Note: Please do not use any quotation marks for the API Key.**

This will install a cronjob running daily at 05:00 exporting both the ADIF log and at 05:10 for the Notes, into the Docker volume called "cloudlog-backup". The cronjob also handles deleting all files older than 30 days (runs at 05:20).

For direct access, you may map the volume to a folder on the server running Docker. From there, you have plenty of options to implement a good backup strategy.

## Support

Please note, this is primarily for my own setup. Feel free to use it (it should work fine). If you find issues, report them on my [Github](https://github.com/jk13xyz/cloudlog-docker/issues). However, **I don't guarantee any support.**

## Source

- This Docker:

    [jk13xyz/cloudlog-docker](https://github.com/jk13xyz/cloudlog-docker)

- Cloudlog:

    [magicbug/cloudlog](https://github.com/magicbug/cloudlog)
