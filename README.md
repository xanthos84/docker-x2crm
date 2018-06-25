compose-x2crm
===============

# Introduction

Docker image + docker-compose files for running X2CRM community open source edition (https://www.x2crm.com/).

Uses [nginx](http://wiki.nginx.org/Main) + [PHP-FPM](http://php-fpm.org/) with PHP7.

This image assumes that you have configured your firewall and mysql database settings accordingly.

# Quick Start

docker-compose up -d

Wait around 5 minutes for the installation to complete then browse to `http://<ip-address>/`. Login with default admin user & password:

* username: **admin**
* password: **changeme**

If using in production, please remember to change the passwords in the .env variable + docker-compose.yml files!

# MySQL connection

Either configure the mysql container settings in the docker-compose.yml file or comment those settings out and change the connection settings under the 
x2crm container section to point to an external database.

# Mail Configuration

The image does not include an MTA. Please utilize an external service (such as Gmail) and configure in the admin panel of the running x2crm instance.

# Volumes

Currently the image supports mapping only the entire install directory as a volume, e.g:

`/var/www/data:/data/upload/`

# Environment Variables for the mariadb container

`MYSQL_ROOT_PASSWORD`
The password to use when connecting to the database as root (CAUTION: for security reasons, recommend setting this in the included .env file)

`MYSQL_DATABASE`
The name of the database to create

`MYSQL_USER`
The name of the standard user to create

`MYSQL_PASSWORD`
The password to use when connecting to the database as a standard user (CAUTION: for security reasons, recommend setting this in the included .env file)


# Environment Variables for the X2CRM container

`CRM_DB_HOST`
Which database host to point the app to. You can point it to the IP of your mariadb container or to an external mysql host

`CRM_DB_NAME`
The name of the database to connect to

`CRM_DB_USER`
The name of the user to use when connecting to the database

`CRM_DB_PASSWORD`
The password to use when connecting to the database (CAUTION: for security reasons, recommend setting this in the included .env file)

`CRM_ADMIN_EMAIL`
The email address to use for the CRM admin user

`CRM_ADMIN_PASSWORD`
The password to use for the CRM admin user (CAUTION: for security reasons, recommend setting this in the included .env file)

`CRM_ADMIN_USER`
The login name to use for the CRM admin user

# License

This image and source code is made available under the MIT licence. See the LICENSE file for details.

# KNOWN ISSUES:

**Access denied when volume is mapped to the host**

* Make sure SELinux is disabled: ```sudo setenforce 0```
* You must have the www-data user + group present on the host with id '82'
* On the host, execute ```chown -R www-data:www-data path/to/install/dir```
