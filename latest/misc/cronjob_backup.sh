#!/bin/bash

add_cron_job() {
    key=$1

    if [[ ! $key =~ ^cl[a-z0-9]+$ ]]; then
        echo "Error: Invalid key format."
        exit 1
    fi

    echo "0 5 * * * curl --silent https://localhost/backup/adif/$key &>/dev/null" >> /var/www/html/crontab/crontab
    echo "10 5 * * * curl --silent https://localhost/backup/notes/$key &>/dev/null" >> /var/www/html/crontab/crontab
    echo "20 5 * * * root find /var/www/html/backup -name 'logbook_*' -o -name 'notes_*' -type f -printf '%T@ %p\n' | sort -k1,1nr | awk 'NR>30 {print $2}' | xargs rm -f" >> /var/www/html/crontab/crontab
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
