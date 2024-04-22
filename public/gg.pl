
#user  nginx;
worker_processes  1;

#error_log  /var/log/nginx/error.log;
#error_log  /var/log/nginx/error.log  notice;
#error_log  /var/log/nginx/error.log  info;

#pid        /var/run/nginx.pid;

include /etc/nginx/modules.conf.d/*.conf;

events {
    worker_connections  1024;
}


http {
    include       mime.types;
    default_type  application/octet-stream;

    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';

    #access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;
    #tcp_nodelay        on;

    #gzip  on;
    #gzip_disable "MSIE [1-6]\.(?!.*SV1)";

    server_tokens off;

    include /etc/nginx/conf.d/*.conf;
}

server {
    listen 443 ssl;
    server_name wc2024.afc95570.fr;

    ssl_certificate Lets_Encrypt__wc2024.afc95570.fr.pem;
    ssl_certificate_key Lets_Encrypt__wc2024.afc95570.fr.pem;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}



# override global parameters e.g. worker_rlimit_nofile
include /etc/nginx/*global_params;
