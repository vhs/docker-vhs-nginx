FROM nginx

RUN echo 'deb http://ftp.debian.org/debian jessie-backports main' >> /etc/apt/sources.list

RUN apt-get -y update
RUN apt-get -y -t jessie-backports install certbot python-certbot

COPY conf/ /etc/nginx/
COPY certs/ /etc/nginx/certs/
COPY bin/ /usr/sbin/

RUN mkdir -p /var/nginx/letsencrypt

CMD ["nginx"]
