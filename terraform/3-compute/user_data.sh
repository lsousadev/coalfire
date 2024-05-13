#!/bin/bash

# get admin privileges
sudo su

# install httpd
yum update -y
yum install -y httpd.x86_64 mod_ssl

# Create a self-signed certificate and a private key
mkdir -p /etc/httpd/ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/httpd/ssl/apache.key \
    -out /etc/httpd/ssl/apache.crt \
    -subj "/C=US/ST=State/L=City/O=Organization/OU=OrgUnit/CN=example.com"

# Configure Apache to use SSL
echo """
Listen 443 https
<VirtualHost *:443>
    ServerName example.com
    DocumentRoot \"/var/www/html\"
    SSLEngine on
    SSLCertificateFile \"/etc/httpd/ssl/apache.crt\"
    SSLCertificateKeyFile \"/etc/httpd/ssl/apache.key\"
</VirtualHost>
""" > /etc/httpd/conf.d/ssl.conf

# Adjust SELinux settings to allow Apache to use networking
setsebool -P httpd_can_network_connect 1

# Ensure Apache starts on boot and restart the service to apply changes
systemctl enable httpd
systemctl restart httpd

echo "Hello World from $(hostname -f)" > /var/www/html/index.html