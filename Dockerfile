FROM nginx

COPY conf/ /etc/nginx/
COPY certs/ /etc/nginx/certs/
COPY bin/ /usr/sbin/

CMD ["nginx"]
