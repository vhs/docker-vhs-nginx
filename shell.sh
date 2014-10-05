#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
docker build -t hackspace/vhs-nginx $DIR

echo "Killing old instance (if any)"
docker kill vhs-nginx-shell
echo "Removing old instance (if any)"
docker rm vhs-nginx-shell
echo "Starting"
docker run -i --name vhs-nginx-shell \
    --volumes-from vhs-website \
    --link vhs-website:vhs-website \
    --link app:app \
    -v $DIR/logs:/var/log/nginx \
    -t hackspace/vhs-nginx /bin/bash
