#!/usr/bin/env bash

set -o errexit  # exit on error
# set -o nounset  # don't allow unset variables
# set -o xtrace # enable for debugging

usage() {
  printf "Builds and pushes a docker container, assuming the Dockerfile lives in a subdirectory named like the container. Requires docker.\n"

  printf "Usage: $(basename "$0") "
  printf -- "[-h, --help] "
  printf -- "[-v, --version] "
  printf -- "[-t, --tag] "
  printf -- "-c, --container=< container > "
  printf "\n"

  printf "  -%s, --%s\t%s%s\n" "h" "help" "Show this help message." ""
  printf "  -%s, --%s\t%s%s\n" "v" "version" "Show version information." ""
  printf "  -%s, --%s\t%s%s\n" "t" "tag" "Tag for the target repo." "latest"
  printf "  -%s, --%s\t%s%s\n" "c" "container" "Container/Subdirectory. Must be a subdirectory of the current one." ""
  printf "  %s\t%s\n" "DOCKER_USER" "Docker Hub User / Organisation is passed via the environment."
  printf "  %s\t%s\n" "DOCKER_PASS" "Docker Hub password is passed via the environment."
}

version() {
  printf "0.0.1\n"
}

# default values
    opt_help="false"
    opt_version="false"
    opt_container=""
    opt_tag="latest"

# option parsing
OPTSPEC=:hvc:t:
OPTSPEC_LONG=help,version,container:,tag:

SCRIPT=`basename $0`
OPTS=`getopt --name "$SCRIPT" --options $OPTSPEC --long $OPTSPEC_LONG -- "$@"`

while [ $# -gt 0 ]; do
  case "$1" in
    -h | --help) usage; opt_help="true";  exit 0  ;;
    -v | --version) version; opt_version="true";  exit 0  ;;
    -c | --container) opt_container=$2; shift;   ;;
    -t | --tag) opt_tag=$2; shift;   ;;
    --) shift; break ;;
    *) break ;;
  esac
  shift
done

# required option validation
if [ -z "$opt_container" ] || ! [ -d "$opt_container" ] || [ -z "$DOCKER_USER" ] || [ -z "$DOCKER_PASS" ]; then
  usage
  exit 1
fi

# convenience variables
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"
__root="$(cd "$(dirname "${__dir}")" && pwd)" # update this to make it point your project's root

echo $DOCKER_PASS | docker login --username $DOCKER_USER --password-stdin
image=$DOCKER_USER/$opt_container:$opt_tag
cd $opt_container
docker build . -t $image
docker push $image
