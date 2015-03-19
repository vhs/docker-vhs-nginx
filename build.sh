#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
docker build -t hackspace/vhs-nginx $DIR
tar -c nginx.conf ./conf.d/ ./certs/ ./bin/|docker build -t hackspace/vhs-nginx $DIR