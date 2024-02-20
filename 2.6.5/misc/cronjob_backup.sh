#!/bin/bash

add_cron_job() {
    key=$1

    if [[ ! $key =~ ^cl[a-z0-9]+$ ]]; then
        echo "Error: Invalid key format."
        exit 1
    fi

    sed -i "s|^#0 */24 * * * curl --silent https://localhost/backup/adif/|0 */24 * * * curl --silent https://localhost/backup/adif/$key|g" /var/www/html/crontab/crontab
    sed -i "s|^#0 */24 * * * curl --silent https://localhost/backup/notes/|0 */24 * * * curl --silent https://localhost/backup/notes/$key|g" /var/www/html/crontab/crontab
    sed -i "s|^#0 */6 * * * root find /var/www/html/backup -name 'logbook_*' -o -name 'notes_*' -type f -printf '%T@ %p\n' | sort -k1,1nr | awk 'NR>30 {print \$2}' | xargs rm -f|0 */6 * * * root find /var/www/html/backup -name 'logbook_*' -o -name 'notes_*' -type f -printf '%T@ %p\n' | sort -k1,1nr | awk 'NR>30 {print \$2}' | xargs rm -f|g" /var/www/html/crontab/crontab

    
    echo "Cronjobs added successfully."
}

while getopts "K:" opt; do
    case $opt in
        K)
            key=$OPTARG
            add_cron_job "$key"
            ;;
        *)
            echo "Usage: $0 -K <key>"
            exit 1
            ;;
    esac
done

if [ -z "$key" ]; then
    echo "Error: No key provided."
    exit 1
fi
