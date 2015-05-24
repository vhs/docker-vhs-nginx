#!/bin/bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

echo "Building"
$DIR/build.sh

echo "Killing old instance (if any)"
docker kill vhs-nginx-test
echo "Removing old instance (if any)"
docker rm vhs-nginx-test
echo "Starting"
docker run -p 90:80 -p 543:443 -d --name vhs-nginx-test \
    --volumes-from vhs-website \
    --link vhs-website:vhs-website \
    --link app:app \
    -v $DIR/logs:/var/log/nginx \
    -t hackspace/vhs-nginx $1
