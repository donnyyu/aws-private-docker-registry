#!/bin/bash

mkdir ~/docker-registry
cp docker-compose.yml ~/docker-registry/
cd ~/docker-registry
mkdir data
cd
# docker-compose up

cat << EOF >your_domain
server {
        listen 80;
        listen [::]:80;

        root /var/www/your_domain/html;
        index index.html index.htm index.nginx-debian.html;

        server_name your_domain;

        location / {
            # Do not allow connections from docker 1.5 and earlier
            # docker pre-1.6.0 did not properly set the user agent on ping, catch "Go *" user agents
            if (\$http_user_agent ~ "^(docker\/1\.(3|4|5(?!\.[0-9]-dev))|Go ).*$" ) {
              return 404;
            }

            proxy_pass                          http://localhost:5000;
            proxy_set_header  Host              \$http_host;   # required for docker client's sake
            proxy_set_header  X-Real-IP         \$remote_addr; # pass on real client's IP
            proxy_set_header  X-Forwarded-For   \$proxy_add_x_forwarded_for;
            proxy_set_header  X-Forwarded-Proto \$scheme;
            proxy_read_timeout                  900;
        }
}
EOF
sudo cp your_domain /etc/nginx/sites-available/your_domain

sudo ln -s /etc/nginx/sites-available/your_domain /etc/nginx/sites-enabled/

sudo systemctl restart nginx

## Setting Up Authentication

sudo apt install apache2-utils -y
sudo mkdir ~/docker-registry/auth
cd ~/docker-registry/auth

sudo htpasswd -Bc registry.password donny

# Secure Nginx with Let's Encrypt

sudo apt install -y certbot python3-certbot-nginx
sudo systemctl reload nginx

sudo ufw allow 'Nginx Full'
sudo ufw delete allow 'Nginx HTTP'

sudo ufw status
sudo certbot --nginx -d your_domain 

## start docker registry
cd ~/docker-registry

sudo apt install docker-compose -y
docker-compose up -d
sudo systemctl restart nginx
