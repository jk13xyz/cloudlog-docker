#!/bin/bash

add_cron_job() {
    key=$1  

    if [[ ! $key =~ ^cl[a-z0-9]+$ ]]; then
        echo "Error: Invalid key format."
        exit 1
    fi

    sed -i -e "s/^# \(.*\)\/adif\/ \(.*\)$/ \1\/adif\/$key \2/" \
       -e "s/^# \(.*\)\/notes\/ \(.*\)$/ \1\/notes\/$key \2/" \
       -e 's/^# //' -e '/^\s*$/d' /var/www/html/crontab/crontab
    
    cp /var/www/html/crontab/crontab /etc/crontab

    echo "Cronjobs added successfully to crontab file."
    
    echo "Will restart cron service now."    

    service cron restart

    echo "All done."

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
