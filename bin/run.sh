#!/bin/bash

echo "Swapping out ENV Vars"
/usr/sbin/replace_env.sh

echo "Starting NGINX"
nginx
