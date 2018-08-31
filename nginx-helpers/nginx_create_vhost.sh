#!/bin/bash

# CONSTANTS
readonly TEMPLATE_DIR="/opt/nxhelper/templates"
readonly VHOST_DIR="/etc/nginx/sites-available"
readonly WWW_DIR="/var/www"

# FUNCTIONS
function path_check()
{
    if [ ! -d $TEMPLATE_DIR ] && [ ! -d $VHOST_DIR ] && [ ! -d $WWW_DIR ]; then
        echo "Configured paths are invalid. Check them or fix the CONSTANTS at the top"
        exit 3
    fi    
}

function create_project_directory()
{
    echo "mkdir $WWW_DIR/$1"
    echo "mkdir $WWW_DIR/$1/public_html"
    echo "chown -R :www-data $WWW_DIR/$1"
}

function copy_template()
{
    echo "cp $TEMPLATE_DIR/$1.dist $VHOST_DIR/$2"
    echo "seds..."
}

function configure_database()
{
    echo "mysql -u root"
}

# SCRIPT MAIN
echo "Nginx VHost creator"

if [ `whoami` != "root" ]; then
    echo "This script requires root permissions"
    exit 2
fi

if [ $# -ne 3 ]; then
    echo "Usage: $0 site_domain template create_db"
    echo "    site_domain: full-qualified domain name (FQDN) without www"
    echo "    template: vhost template to use"
    echo "    create_db: [yes|no] should script create MySQL DB?"
    exit 1
fi

#path_check
create_project_directory $1
copy_template $2 $1
configure_database $3

echo "All done! Please verify $VHOST_DIR/$1 configuration file before enabling it."

