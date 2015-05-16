#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
docker build -t hackspace/vhs-nginx $DIR
<<<<<<< HEAD
=======
tar -c nginx.conf ./conf.d/ ./certs/ ./bin/|docker build -t hackspace/vhs-nginx $DIR
>>>>>>> d581767496ec9396c7bf628d7af88932f782b260
