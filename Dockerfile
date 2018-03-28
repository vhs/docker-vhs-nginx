FROM nginx

RUN apt-get -y update
RUN apt-get -y install wget gnupg

RUN wget https://nginx.org/keys/nginx_signing.key -O - | apt-key add -

RUN apt-get -y update

COPY conf/ /etc/nginx/
COPY certs/ /etc/nginx/certs/
COPY bin/ /usr/sbin/

CMD ["nginx"]
