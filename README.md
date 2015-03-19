# Nginx docker instance

Basic nginx reverse proxy for discourse and wordpress. Both discourse and wordpress containers
must be running first.

## Starting

```
./start.sh
```

## How to use

Bascially this container contains only nginx and the configuration specific to VHS. Currently it acts as a proxy for discourse and 
the nginx front-end for wordpress/doku.

### Linking containers

When you start up a container such as wordpress you can pick what ports are exposed to other containers. In our case we have php5-fpm 
running and listening on port 9000, this is exposed in the Dockerfile for that project.

After you link a container there is no guarntee that each container will listen on the same port, it will try to use that port but in case of port
conflicts it will pick another. To work around this Docker will have environment variables that will direct you to the correct port mapping.

Here is an example of the variables:

```
VHS_WEBSITE_PORT_3306_TCP_PORT=3306
VHS_WEBSITE_PORT_9000_TCP_ADDR=172.17.2.91
VHS_WEBSITE_PORT_9000_TCP_PROTO=tcp
VHS_WEBSITE_NAME=/vhs-nginx-shell/vhs-website
VHS_WEBSITE_PORT_3306_TCP=tcp://172.17.2.91:3306
VHS_WEBSITE_PORT_80_TCP_PORT=80
VHS_WEBSITE_PORT_9000_TCP_PORT=9000
VHS_WEBSITE_ENV_DEBIAN_FRONTEND=noninteractive
VHS_WEBSITE_PORT_3306_TCP_ADDR=172.17.2.91
VHS_WEBSITE_PORT_80_TCP_ADDR=172.17.2.91
VHS_WEBSITE_PORT_80_TCP_PROTO=tcp
VHS_WEBSITE_PORT=tcp://172.17.2.91:80
VHS_WEBSITE_PORT_3306_TCP_PROTO=tcp
VHS_WEBSITE_PORT_9000_TCP=tcp://172.17.2.91:9000
VHS_WEBSITE_PORT_80_TCP=tcp://172.17.2.91:80
```

In this container environment variables are substituted in the nginx configuration so to connect our fpm worker from wordpress the config looks like this:

```
fastcgi_pass {{VHS_WEBSITE_PORT_9000_TCP_ADDR}}:{{VHS_WEBSITE_PORT_9000_TCP_PORT}};
```

### Adding file systems from the host

You can also mount directories from the host, edit the start.sh and add any directory you like using the -v command.

### Adding a file system from another container

Once you declare a volume in your other container you can have these directories mounted using the --volumes-from argument. 
The wordpress container is an example of this. The wordpress filesystem is mounted so it can serve static content as if it was local
without having to proxy just for static content.

### When child containers are restarted

This is important, if you rebuild a child container it will get a new ip/port and this container will need to be restarted to pick up
the changes. 

A rebuild will take place anytime you run start.sh

## Testing

```
shell.sh
```

This will launch a shell in the context of your container. This is a new container but it will allow you to test commands, check filesystems etc. 

If you want to try nginx from this shell then run:

```
run.sh &
```

This is the command that is normally run from the docker container, see Dockerfile
