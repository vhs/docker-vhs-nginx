#!/bin/bash

# An overly complicated create script to make things easy to get up and running on other machines
# In production it will mount /www and /var/lib/mysql to the host
# However in dev mode /var/lib/mysql will mount to a data container instead, this is to get around file permissions of the host

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

TEMPLATE='vhs-nginx'
NAME=$TEMPLATE

function print_help { 
    printf "Create a container from the ${TEMPLATE} template and start it\n\n"
    printf "Usage: create.sh\n"
    printf "Options:\n"
    printf "    -f         stop and remove existing container before creating\n"
    printf "    -h         there is no help for you\n\n"
    printf "    -w         do not link vhs-websitei\n"
    printf "    -d         do not link discourse\n"
    printf "    -a         do not link api\n"
    print_docker_help
    exit 0
} 

function print_docker_help {
    echo "Docker Actions:"
    echo "    Stopping       docker stop $NAME"
    echo "    Starting       docker start $NAME"
    echo "    Shell access   docker exec -it $NAME /bin/bash"
}

# extract options and their arguments into variables.
while getopts :hfwdat opt; do
    case $opt in
        f) force=true;;
        h) print_help;;
        w) no_website=true;;
        d) no_discourse=true;;
        a) no_api=true;;
        t) test_config=true; force=true; NAME=$NAME-test;;
        ?) echo "Invalid option: -$OPTARG" >&2; print_help; exit 1;;
        :) echo "Option -$OPTARG requires an argument." >&2; print_help; exit 1;;
    esac
done


# Check if the container exists
exists=false
running=`docker inspect -f {{.State.Running}} ${NAME} 2>/dev/null`
if [ "$?" == "0" ]; then
    exists=true
fi 

RUN_OPTS="-v $DIR/logs:/var/log/nginx";
if [ "$no_website" != true ]; then RUN_OPTS="$RUN_OPTS --volumes-from vhs-website --link vhs-website:vhs-website --link vhs-api:vhs-api --link isvhsopen:isvhsopen --link grafana:grafana"; fi
if [ "$no_discourse" != true ]; then RUN_OPTS="$RUN_OPTS --link app:app"; fi

# Only stop the container if force is used
if [ "$running" == "true" ]; then
    if [ "$force" == true ]; then
        echo "Container is running, stopping first"
        docker stop $NAME > /dev/null
    else
        echo "Container is running, use -f to stop and remove first"
        exit 1
    fi
fi

# Only remove the container if force is used
if [ "$exists" = true ]; then
    if [ "$force" == true ]; then
        echo "Removing existing container"
        docker rm $NAME > /dev/null
    else
        echo "Container already exists, use -f to remove first"
        exit 1
    fi 
fi

if [ "$test_config" == true ]; then
    docker run -it --name $NAME $RUN_OPTS -t vanhack/$TEMPLATE nginx -t
    exit $?
else
    docker run --restart=always -p 80:80 -p 443:443 -d --name $NAME \
        $RUN_OPTS \
        --restart=always \
        -t vanhack/$TEMPLATE $COMMAND
fi

if [ "$?" != "0" ]; then
    echo "Error running docker run, aborting. Did you build the template first?"
    exit 1
fi

echo "Container has been created and should now be running."
echo ""
print_docker_help
