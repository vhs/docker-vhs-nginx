FROM nginx

RUN echo 'deb http://ftp.debian.org/debian jessie-backports main' >> /etc/apt/sources.list

RUN apt-get -y update
RUN apt-get -y install wget

RUN apt-get -y update

RUN wget https://nginx.org/keys/nginx_signing.key -O - | apt-key add -
RUN apt-get -y -t jessie-backports install certbot python-certbot

COPY conf/ /etc/nginx/
COPY certs/ /etc/nginx/certs/
COPY bin/ /usr/sbin/

CMD ["nginx"]
