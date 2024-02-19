#!/bin/bash

add_cron_job() {
    key=$1

    if [[ ! $key =~ ^cl[a-z0-9]+$ ]]; then
        echo "Error: Invalid key format."
        exit 1
    fi

    echo "0 */24 * * * curl --silent https://localhost/backup/adif/$key &>/dev/null" >> /etc/crontab
    echo "0 */24 * * * curl --silent https://localhost/backup/notes/$key &>/dev/null" >> /etc/crontab    
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
