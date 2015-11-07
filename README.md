# Nginx docker instance

Basic nginx reverse proxy for discourse and wordpress. Both discourse and wordpress containers
must be running first.

## Building

./build.sh
```
## Creating

./create.sh [-f] [-t] [-d] [-w]
```
This will create a container with the name vhs-nginx, if it already exists -f (force) will remove and re-create.

### Testing the nginx config

After the image has been built, the config can be tested using -t

```bash
$ ./create.sh -t
```

### Skip linking

If you are running this without other containers you can create the container without vhs-website (-w) or discourse (-d)
