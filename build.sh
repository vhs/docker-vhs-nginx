#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

TEMPLATE='vhs-nginx'
BUILD_OPTS=''

function print_help {
    printf "Build the template for ${TEMPLATE}\n\n"
    printf "Usage: build.sh\n"
    printf "Options:\n"
    printf "    -n  skip the cache when building, will force a new install\n"
    exit 0
}

# extract options and their arguments into variables.
while getopts :nh opt; do
    case $opt in
        n) BUILD_OPTS="${BUILD_OPTS} --no-cache"; shift ;;
        h) print_help; shift ;;
        ?) echo "Invalid option: -$OPTARG" >&2; print_help; exit 1;
    esac
done

docker build -t hackspace/$TEMPLATE $BUILD_OPTS $DIR

echo "Your template hackspace/$TEMPLATE has been successfully built"
echo "To create a new container based on this template then run create.sh"
echo "To test the nginx config first run create.sh -t"
