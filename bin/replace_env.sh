#!/bin/bash

for e in `env`
do
ENV_NAME=${e%=*}
ENV_VAL=${e#*=}
sed -i "s|{{${ENV_NAME}}}|${ENV_VAL}|g" /etc/nginx/conf.d/*
done
