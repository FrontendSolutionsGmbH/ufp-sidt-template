#!/usr/bin/env bash

log(){
	echo "[$(date +"%Y-%m-%d %H:%M:%S")] $@"
}

log "Stack.sh called"

###
# Variables
###
SCRIPT_PATH=$(realpath "$0")
SCRIPT_NAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
SCRIPT_HOME=${SCRIPT_PATH%$SCRIPT_NAME}


START=1
STOP=0

STACK_INFRA=0
STACK_DEBUG=0
STACK_SERVICE=1
STACK_TEST=0

BACKGROUND=""
CREATE=0

COMPOSE_PROJECT_NAME="ct"

RESULT=0
###
# Functions
###

help() {
  echo " Starts/Stops the local stack and their debug-tools."
  echo " Options:"
  echo "   -h          Show this help"
  echo "   -p          Pulls the latest docker images"
  echo "   -b          Starts stack in background with -d"
  echo "   -c          do not create container stacks"
  echo "   -l          Show the echos"
  echo "   -u <stack>  Starts the given stack. Possible stacks see below!"
  echo "   -d <stack>  Stops the given stack. Possible stacks see below!"
  echo ""
  echo "   Possible Stacks:"
  echo "     infra     The infrastructure needed by the services"
  echo "     service   The order-process involved services"
  echo "     debug     The debug tools"
  echo "     all       All these stacks"
  echo ""
  echo " Default behavior: Starts the service only"
  echo ""
  echo " (continued) author: ck@froso.de"
  echo " (initial) author: s.schumann@tarent.de"
}

pullAllImages() {
    cd ${SCRIPT_HOME}/ct/
    docker-compose -f ${SCRIPT_HOME}/ct/docker-compose-service.yml pull
    docker-compose -f ${SCRIPT_HOME}/ct/docker-compose-infrastructure.yml pull
    docker-compose -f ${SCRIPT_HOME}/ct/docker-compose-debug.yml pull
    docker-compose -f ${SCRIPT_HOME}/ct/docker-compose-test.yml pull
    cd -
}

logAllImages() {
    cd ${SCRIPT_HOME}/ct/
    docker-compose -f ${SCRIPT_HOME}/ct/docker-compose-service.yml logs
    docker-compose -f ${SCRIPT_HOME}/ct/docker-compose-test.yml logs
    docker-compose -f ${SCRIPT_HOME}/ct/docker-compose-debug.yml logs
    docker-compose -f ${SCRIPT_HOME}/ct/docker-compose-infrastructure.yml logs
    cd -
}

chooseServices() {
    case $1 in
       infra) STACK_INFRA=1;;
       debug) STACK_DEBUG=1 ;;
       service) STACK_SERVICE=1 ;;
       test) STACK_TEST=1 ;;
       all) STACK_SERVICE=1; STACK_DEBUG=1; STACK_INFRA=1;STACK_TEST=1;;
    esac
}

getEnv() {
    cat ${ENV_FILE} | grep ${1} | cut -d\= -f2
}

startInfraStack() {
    cd ${SCRIPT_HOME}/ct/


    docker-compose -f ${SCRIPT_HOME}/ct/docker-compose-infrastructure.yml -p ${COMPOSE_PROJECT_NAME} ${BACKGROUND}
    cd -
}

stopInfraStack() {
    cd ${SCRIPT_HOME}/ct/
    if [ "$CREATE" -eq "1" ]; then
    docker-compose -f ${SCRIPT_HOME}/ct/docker-compose-infrastructure.yml build --no-cache
    fi

    docker-compose -f ${SCRIPT_HOME}/ct/docker-compose-infrastructure.yml -p ${COMPOSE_PROJECT_NAME} down
    cd -
}

startDebugStack(){
    cd ${SCRIPT_HOME}/ct/

    docker-compose -f ${SCRIPT_HOME}/ct/docker-compose-debug.yml -p ${COMPOSE_PROJECT_NAME} up ${BACKGROUND}
    cd -
}

stopDebugStack(){
    cd ${SCRIPT_HOME}/ct/

	if [ "$CREATE" -eq "1" ]; then
    docker-compose -f ${SCRIPT_HOME}/ct/docker-compose-debug.yml build --no-cache
    fi

    docker-compose -f ${SCRIPT_HOME}/ct/docker-compose-debug.yml -p ${COMPOSE_PROJECT_NAME} down
    cd -
}

startServiceStack(){
	log "Starting Service Stack"
    cd ${SCRIPT_HOME}/ct/

    docker-compose -f ${SCRIPT_HOME}/ct/docker-compose-service.yml -p ${COMPOSE_PROJECT_NAME} up ${BACKGROUND}
    RESULT=$?
    cd -

	log "Returning Service Stack"
}

stopServiceStack(){
	log "Stopping Service Stack"

	if [ "$CREATE" -eq "1" ]; then
		./build.sh
		docker-compose -f ${SCRIPT_HOME}/ct/docker-compose-service.yml build --no-cache
	fi

    cd ${SCRIPT_HOME}/ct/
    docker-compose -f ${SCRIPT_HOME}/ct/docker-compose-service.yml -p ${COMPOSE_PROJECT_NAME} down
    cd -

	log "Stopping Service Stack End"
}

startTestStack(){

    cd ${SCRIPT_HOME}/ct/


    docker-compose -f ${SCRIPT_HOME}/ct/docker-compose-test.yml  -p ${COMPOSE_PROJECT_NAME} up --exit-code-from robot-test --abort-on-container-exit ${BACKGROUND}
    RESULT=$?
    cd -
	log "Starting Test Stack End ${RESULT}"
}

stopTestStack(){
    cd ${SCRIPT_HOME}/ct/

    if [ "$CREATE" -eq "1" ]; then
		docker-compose -f ${SCRIPT_HOME}/ct/docker-compose-test.yml build --no-cache
	fi

    docker-compose -f ${SCRIPT_HOME}/ct/docker-compose-test.yml -p ${COMPOSE_PROJECT_NAME} down
    cd -
}


###
# Main
###

if [ "$#" -ge 1 ]; then
    STACK_SERVICE=0
fi

while getopts 'u:d:hplbc' OPTION; do
  case $OPTION in
    b)
        BACKGROUND="-d"
    ;;
    p)
        pullAllImages
    ;;
    c)
        CREATE=1
    ;;
    l)
        logAllImages
    ;;
    u)
        START=1
        STOP=0
        chooseServices $OPTARG
    ;;
    d)
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


log "SCRIPT_PATH=${SCRIPT_PATH}"
log "SCRIPT_NAME=${SCRIPT_NAME}"
log "SCRIPT_HOME=${SCRIPT_HOME}"
log "START=${START}"
log "STOP=${STOP}"
log "STACK_INFRA=${STACK_INFRA}"
log "STACK_DEBUG=${STACK_DEBUG}"
log "STACK_SERVICE=${STACK_SERVICE}"
log "STACK_TEST=${STACK_TEST}"
log "CREATE=${CREATE}"


if [ "$STACK_INFRA" -eq "1" ]; then
    if [ "$START" -eq "1" ];then startInfraStack ;fi
    if [ "$STOP" -eq "1" ];then stopInfraStack ;fi
fi
if [ "$STACK_DEBUG" -eq "1" ]; then
    if [ "$START" -eq "1" ];then startDebugStack ;fi
    if [ "$STOP" -eq "1" ];then stopDebugStack ;fi
fi

if [ "$STACK_SERVICE" -eq "1" ]; then
    if [ "$START" -eq "1" ];then startServiceStack ;fi
    if [ "$STOP" -eq "1" ];then stopServiceStack ;fi
fi

if [ "$STACK_TEST" -eq "1" ]; then
    if [ "$START" -eq "1" ];then startTestStack ;fi
    if [ "$STOP" -eq "1" ];then stopTestStack ;fi
fi

log "Stack.sh exit"
exit ${RESULT}
