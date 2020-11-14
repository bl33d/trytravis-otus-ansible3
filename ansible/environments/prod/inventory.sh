#!/bin/bash

show_help() {
    printf "usage: inventory.sh --list %s\n
This script, when run with the --list option, sends ansible inventory in JSON format to STDOUT. %s\n"
}

gen_json_inventory() {
    cd ../terraform/prod
    # From terraform output we take external_ip_address_app, leave only the address and remove the quotes
    app_server_ip=`terraform show -no-color | grep external_ip_address_app | cut -d " " -f3 | sed 's/"//g'`
    # Same as above, but for external_ip_address_db
    db_server_ip=`terraform show -no-color | grep external_ip_address_db | cut -d " " -f3 | sed 's/"//g'`
    cat << EOF > /tmp/inventory_ini_format.tmp
[app]
appserver ansible_host=${app_server_ip}
[db]
dbserver ansible_host=${db_server_ip}
# comment here
EOF
    ansible-inventory -i /tmp/inventory_ini_format.tmp --list
    rm /tmp/inventory_ini_format.tmp
}

case $1 in
    -h|--help)
        show_help
        exit
        ;;
    --list)
        gen_json_inventory
        exit
        ;;
    -?*)
        printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
        ;;
    *)
        printf "Dynamic inventory for OTUS DevOps, Ansible-1 homework.
This script, when run with the --list option, sends ansible inventory in JSON format to STDOUT. %s\n"
        ;;
esac
