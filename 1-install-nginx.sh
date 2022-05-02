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

sudo -i
sudo cat << EOF >/etc/nginx/sites-available/your_domain
server {
        listen 80;
        listen [::]:80;

        root /var/www/your_domain/html;
        index index.html index.htm index.nginx-debian.html;

        server_name your_domain;

        location / {
                try_files $uri $uri/ =404;
        }
}
EOF
exit
sudo ln -s /etc/nginx/sites-available/your_domain /etc/nginx/sites-enabled/

sudo mv nginx.conf /etc/nginx/nginx.conf

sudo nginx -t
sudo systemctl restart nginx


## Secure Nginx with Let's Encrypt

sudo apt install -y certbot python3-certbot-nginx
sudo systemctl reload nginx

sudo ufw allow 'Nginx Full'
sudo ufw delete allow 'Nginx HTTP'

sudo ufw status
sudo certbot --nginx -d your_domain 