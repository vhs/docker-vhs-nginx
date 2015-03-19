#!/bin/bash

echo "Killing old instance (if any)"
docker kill vhs-nginx
echo "Removing old instance (if any)"
docker rm vhs-nginx
echo "Starting"
docker run -p 80:80 -p 443:443 -d --name vhs-nginx \
    --volumes-from vhs-website \
    --link vhs-website:vhs-website \
    --link app:app \
    -v $DIR/logs:/var/log/nginx \
    -t hackspace/vhs-nginx $1
