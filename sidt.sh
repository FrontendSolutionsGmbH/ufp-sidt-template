#!/usr/bin/env bash
log(){
	echo "[$(date +"%Y-%m-%d %H:%M:%S")] $@"
}

log ""
log "SIDT - Service Infrastructure Debug Test"
log ""

ACTIVE_STACKS=()


###
# Variables
###
PROJECT_NAME="ufp-sidt-example-app"
VERSION=6
SCRIPT_PATH=$(realpath "$0")
SCRIPT_NAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
SCRIPT_HOME=${SCRIPT_PATH%$SCRIPT_NAME}

STACK_LOCATION="${SCRIPT_HOME}ct/docker-compose-"
STACK_LOCATION_SERVICE="${SCRIPT_HOME}ct/docker-compose-service.yml"
STACK_LOCATION_INFRA="${SCRIPT_HOME}ct/docker-compose-infrastructure.yml"
STACK_LOCATION_DEBUG="${SCRIPT_HOME}ct/docker-compose-debug.yml"
STACK_LOCATION_TEST="${SCRIPT_HOME}ct/docker-compose-test.yml"


START=1
STOP=0

STACK_INFRA=0
STACK_DEBUG=0
STACK_SERVICE=0
STACK_TEST=0
LOG_STACK=0
PULL_STACK=0
DEBUG=0


BACKGROUND=""
CREATE=0

COMPOSE_PROJECT_NAME="${PROJECT_NAME}componenttest"

RESULT=0
###
# Functions
###

help() {
  echo " "
  echo " SIDT Cli"
  echo " "
  echo " Starts/Stops the local stack and their debug-tools."
  echo " Options:"
  echo "   -h          Show this help"
  echo "   -p <stack>  Pulls the latest docker images"
  echo "   -b          Starts stack in background with -d"
  echo "   -c          (re-)create container stacks"
  echo "   -l <stack>  Show the logs of stacks"
  echo "   -u <stack>  Starts the given stack. Possible stacks see below!"
  echo "   -d <stack>  Stops the given stack. Possible stacks see below!"
  echo ""
  echo "   Possible Stacks:"
  echo "     infra     The infrastructure needed by the services"
  echo "     service   The involved services"
  echo "     debug     The debug tools"
  echo "     all       All these stacks"
  echo "     *any      Any other ct/docker-compose-[*any].yml"
  echo ""
  echo " Default behavior: Does Nothing"
  echo ""
  echo " (continued) author: ck@froso.de"
  echo " (initial) author: s.schumann@tarent.de"
}

pullStack() {
    COMPOSE_FILENAME=$1

	log "Pulling Stack ${COMPOSE_FILENAME}"
    docker-compose -f ${COMPOSE_FILENAME} pull
}

logStack() {
    COMPOSE_FILENAME=$1
    log "Loggin Stack ${COMPOSE_FILENAME}"
    docker-compose -f ${COMPOSE_FILENAME} logs
}

startStack() {
    COMPOSE_FILENAME=$1

	log "(Re-)Starting Stack ${COMPOSE_FILENAME}"

	stopStack  $COMPOSE_FILENAME
    if [ "$CREATE" -eq "1" ]; then
	log "(Re-)Creating Stack ${COMPOSE_FILENAME}"

	  if [ "$COMPOSE_FILENAME" = "$STACK_LOCATION_SERVICE" ]; then
    	#    hnandle call to docker build of main service in root Dockerfile
	log "Building main docker image $PROJECT_NAME:$VERSION"
        docker build   --no-cache -t $PROJECT_NAME:$VERSION  -t $PROJECT_NAME:latest .
    fi

		docker-compose -f $COMPOSE_FILENAME build --no-cache  --force-rm

	fi

    docker-compose -f $1 -p ${COMPOSE_PROJECT_NAME} up ${BACKGROUND}
}
stopStack() {

    COMPOSE_FILENAME=$1
	log "Stopping Stack ${COMPOSE_FILENAME}"

    docker-compose -f ${COMPOSE_FILENAME} -p ${COMPOSE_PROJECT_NAME} down
}

logAllImages() {
    logStack ${STACK_LOCATION_SERVICE}
    logStack ${STACK_LOCATION_INFRA}
    logStack ${STACK_LOCATION_DEBUG}
    logStack ${STACK_LOCATION_TEST}
}

pullAllImages() {
    pullStack ${STACK_LOCATION_SERVICE}
    pullStack ${STACK_LOCATION_INFRA}
    pullStack ${STACK_LOCATION_DEBUG}
    pullStack ${STACK_LOCATION_TEST}
}

chooseServices() {
    case $1 in
       all)
            ACTIVE_STACKS+=("infra")
            ACTIVE_STACKS+=("service")
            ACTIVE_STACKS+=("debug")
            ACTIVE_STACKS+=("test")
            ;;
     *)
            log "Using input --- $1"
            STACK_NAME=$1
            ACTIVE_STACKS+=("$1")
    esac
}


###
# Main
###

if [ "$#" -ge 1 ]; then
    STACK_SERVICE=0
fi

while getopts 'u:d:p:l:chb' OPTION; do
  case $OPTION in
    b)
    	log "Background flag -b found, starting in background"
        BACKGROUND="-d"
    ;;
    p)
    	log "Pull All Images flag -p found, pulling all images"
        chooseServices $OPTARG
    ;;
    c)
    	log "Create flag -c found, (re-)creating stacks/images"
        CREATE=1
    ;;

    l)
    	log "Log flag -l found, logging  stacks"
#        logAllImages
		LOG_STACK=1
        START=0
        STOP=0
        chooseServices $OPTARG
    ;;
    u)
    	log "Start flag -u found, starting"
        START=1
        STOP=0
        chooseServices $OPTARG
    ;;
    d)
    	log "Stop flag -d found, stopping"
        START=0
        STOP=1
        chooseServices $OPTARG
    ;;
    h)
        help
        exit 0
    ;;
  esac
done


log ""
log "SIDT - Performing action on [${ACTIVE_STACKS}]"
log ""
execute(){
    log "Executing ${1}"

    if [ "$STOP" -eq "1" ];then stopStack $1 ;fi
    if [ "$START" -eq "1" ];then startStack $1 ;fi
    if [ "$LOG_STACK" -eq "1" ];then logStack $1 ;fi
    if [ "$PULL_STACK" -eq "1" ];then pullStack $1 ;fi
}

if [ "$DEBUG" -eq "1" ]; then
set -x
fi
          for stack_name in $ACTIVE_STACKS
          do
                execute ${STACK_LOCATION}${stack_name}.yml
          done

log ""
log "SIDT - ${ACTIVE_STACKS}"
log "SIDT - Service Infrastructure Debug Test Exit"
log ""
exit ${RESULT}
