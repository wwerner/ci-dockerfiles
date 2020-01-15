#!/usr/bin/env bash

set -o errexit  # exit on error
# set -o nounset  # don't allow unset variables
# set -o xtrace # enable for debugging

usage() {
  printf "Builds and pushes a docker container, assuming the Dockerfile lives in a subdirectory named like the container. \n\n"
  printf "Requires docker and DOCKER_USER and DOCKER_PASS to be set.\n"

  printf "Usage: $(basename "$0") "
  printf -- "[-h, --help] "
  printf -- "[-v, --version] "
  printf -- "[-t, --tag] "
  printf -- "-c, --container=< container > "
  printf "\n"

  printf "  -%s, --%s\t\t%s%s\n" "h" "help" "Show this help message." ""
  printf "  -%s, --%s\t\t%s%s\n" "v" "version" "Show version information." ""
  printf "  -%s, --%s\t%s%s\n" "c" "container" "Container/Subdirectory. Must be a subdirectory of the current one." ""
  printf "  %s\t\t%s\n" "DOCKER_USER" "Docker Hub User / Organisation is passed via the environment."
  printf "  %s\t\t%s\n" "DOCKER_PASS" "Docker Hub password is passed via the environment."
  printf "  %s\t%s\n" "<container>/tags" "A file named 'tags' containing all tags to attach to the container line by line."
}

version() {
  printf "0.0.2\n"
}

# default values
    opt_container=""

# option parsing
OPTSPEC=:hvc:
OPTSPEC_LONG=help,version,container:

SCRIPT=`basename $0`
OPTS=`getopt --name "$SCRIPT" --options $OPTSPEC --long $OPTSPEC_LONG -- "$@"`

while [ $# -gt 0 ]; do
  case "$1" in
    -h | --help) usage; exit 0  ;;
    -v | --version) version; exit 0  ;;
    -c | --container) opt_container=$(echo $2 | sed s/\\/$//); shift;   ;;
    --) shift; break ;;
    *) break ;;
  esac
  shift
done

# option validation
if [ -z "$opt_container" ] || ! [ -d "$opt_container" ] || [ -z "$DOCKER_USER" ] || [ -z "$DOCKER_PASS" ] || [ ! -f "$opt_container/tags" ]; then
  usage
  exit 1
fi

echo $DOCKER_PASS | docker login --username $DOCKER_USER --password-stdin

cd $opt_container
export tags=$(cat tags | awk -v image="$opt_container" -v user="$DOCKER_USER" '{print "-t " user "/" image ":" $1}' ORS=' ')
docker build . $tags

while read t; do
  echo docker push $DOCKER_USER/$opt_container:$t
done <tags
