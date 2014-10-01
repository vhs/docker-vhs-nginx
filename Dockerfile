FROM dockerfile/nginx

ADD nginx.conf /etc/nginx/
ADD conf.d/ /etc/nginx/conf.d
ADD certs/ /etc/nginx/certs/
ADD bin/ /usr/sbin/

CMD ["run.sh"]
