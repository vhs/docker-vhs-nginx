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
    printf "    -t         test mode\n"
    printf "    -f         stop and remove existing container before creating\n"
    printf "    -h         there is no help for you\n\n"

    printf "    -a         do not link api\n"
    printf "    -b         do not link deletron3030\n"
    printf "    -c         do not link discourse\n"
    printf "    -d         do not link grafana\n"
    printf "    -e         do not link influxdb\n"
    printf "    -g         do not link isvhsopen\n"
    printf "    -i         do not link itlb\n"
    printf "    -j         do not link portal\n"
    printf "    -k         do not link vhs-website\n"

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
while getopts :tfhabcdegijk opt; do
    case $opt in
        t) test_config=true; force=true; NAME=$NAME-test;;
        f) force=true;;
        h) print_help;;

        a) no_api=true;;
        b) no_deletron3030=true;;
        c) no_discourse=true;;
        d) no_grafana=true;;
        e) no_influxdb=true;;
        g) no_isvhsopen=true;;
        i) no_itlb=true;;
        j) no_portal=true;;
        k) no_website=true;;
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
RUN_OPTS="$RUN_OPTS -v /etc/letsencrypt:/etc/letsencrypt";
RUN_OPTS="$RUN_OPTS -v /var/lib/letsencrypt:/var/lib/letsencrypt";
RUN_OPTS="$RUN_OPTS -v /var/containers/shared/.well-known:/var/nginx/.well-known";

if [ "$no_api" != true ] ; then RUN_OPTS="$RUN_OPTS --link vhs-api:vhs-api"; fi

if [ "$no_deletron3030" != true ] ; then RUN_OPTS="$RUN_OPTS --link deletron3030:deletron3030"; fi

if [ "$no_discourse" != true ]; then RUN_OPTS="$RUN_OPTS --link app:app"; fi

if [ "$no_grafana" != true ] ; then RUN_OPTS="$RUN_OPTS --link grafana:grafana"; fi

if [ "$no_influxdb" != true ] ; then RUN_OPTS="$RUN_OPTS --link influxdb:influxdb"; fi

if [ "$no_isvhsopen" != true ] ; then RUN_OPTS="$RUN_OPTS --link isvhsopen:isvhsopen"; fi

if [ "$no_itlb" != true ] ; then RUN_OPTS="$RUN_OPTS --link vhs-itlb:vhs-itlb"; fi

if [ "$no_portal" != true ] ; then RUN_OPTS="$RUN_OPTS --link vhs-portal:vhs-portal"; fi

if [ "$no_website" != true ]; then RUN_OPTS="$RUN_OPTS --volumes-from vhs-website --link vhs-website:vhs-website"; fi

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
