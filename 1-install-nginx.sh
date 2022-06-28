#!/bin/bash

## Installation
sudo apt update
sudo apt -y install nginx

sudo ufw app list

sudo ufw --force enable
sudo ufw allow OpenSSH

sudo ufw allow 'Nginx HTTP'

sudo ufw status

sudo systemctl enable nginx
sudo systemctl restart nginx
sudo systemctl status nginx

## Setting Up Server Blocks
sudo mkdir -p /var/www/your_domain/html
sudo chown -R $USER:$USER /var/www/your_domain/html
sudo chmod -R 755 /var/www/your_domain

sudo cat << EOF > /var/www/your_domain/html/index.html
<html>
    <head>
        <title>Welcome to your_domain!</title>
    </head>
    <body>
        <h1>Success!  The your_domain server block is working!</h1>
    </body>
</html>
EOF

sudo cp nginx.conf /etc/nginx/nginx.conf

sudo nginx -t
sudo systemctl restart nginx

