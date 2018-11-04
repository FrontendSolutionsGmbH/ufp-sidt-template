#!/usr/bin/env bash


loadEnv(){

filename=".env"
while IFS='=' read -r key value ; do
    export $key=$value
    echo "Name read from file - $key -- $value"
done < "$filename"

}
  loadEnv
log(){
	echo "[$(date +"%Y-%m-%d %H:%M:%S")] $@"
}

logDivider(){

	log "--------------------------------------------------------------------------------"
}

    logDivider
log ""
log "SIDT HELM - Service Infrastructure Debug Test"
log ""


    logDivider
THIS_APP_AREAS=(componenttest)
THIS_APP_SERVICES=(service-dependencies service client-dependencies client )

TEST=0
MAKE=0
TEARDOWN=1
INFO=0

help() {
  echo " "
  echo " SIDT Helm"
  echo " "
  echo " ./sidt-helm.sh [options] "
  echo " "
  echo " Helm control for sidt organised stacks, use to build and test your suite. Control Starting and stopping indivudally using sidt.sh"
  echo " Options:"
  echo "   -h           Show this help"
  echo "   -i           Show info about apps/areas"
  echo "   -t           Test all areas"
  echo "   -b           No Teardown"
  echo "   -m           Make all Applications/Services/Dockerfiles"
  echo ""
  echo " Default behavior: Creates all Services and Executes all Areas "
  echo ""
  echo " (author) author: ck@froso.de"
}

while getopts 'ihtmb' OPTION; do
  case $OPTION in

    m)
    	log "Make flag found -m creating application Dockerfiles"
        MAKE=1
    ;;
	i)
    	log "Info flag found -i printing stats of found apps and area stacks"
        INFO=1
    ;;

    t)
    	log "Test flag -t found, starting tests for all areas"
        TEST=1
    ;;
    b)
    	log "Teardown flag -b found, keeping stacks alive"
        TEARDOWN=0
    ;;
    h)
        help
        exit 0
    ;;

  esac
done

# Make
#
# Executes a full stack create, test and optional teardown
#
makeApplication(){


  log "Making application $1"
./sidt.sh -m $1
}


exec(){


 ./sidt.sh $1 $2 $3 $4 $5 $6
}


#
# Executes a full stack create, test and optional teardown
#
executeStack(){

  log "Deleting test report folders $(pwd)/stacks/${1}/robot/report"
  rm -rf $(pwd)/stacks/${1}/robot/report

  log "Executing Test $1 delete result was $?"
#  Bring up Stack detached in background, but recreate docker-compose
  exec -a $1 -u all  -c
  exec -a $1 -s all  -c
#  Execute the test in foreground
  exec -a $1 -u test -b  -c
#  Teardown
  if [ "${TEARDOWN}" -eq "1" ];then
  exec -a $1 -d all
  fi
}

findStacks(){

  SERVICES=()

  for i in $1/docker-compose*.yml;
  do # Whitespace-safe but not recursive.
     SERVICES+=("$i")
  done

  # echo "FOUND: [${SERVICES[*]} "

  for areaCandidate in "${SERVICES[@]}"
  do
    if [  -f ${areaCandidate} ]; then
        VALUE=${areaCandidate//$1\/docker-compose-/}
        VALUE=${VALUE//.yml/}

    log "sidt.sh -a $1 -u ${VALUE} -c"
    else
    log "WANING: not suitable ${areaCandidate}"
    fi
  done
}
findAreas(){

                      logDivider
  SERVICES=()

  log ""
  log "Available Areas"
  log ""
  cd stacks
  for i in *;
  do # Whitespace-safe but not recursive.
    #    echo "musi $i"

    SERVICES+=("$i")
  done

  # echo "FOUND: [${SERVICES[*]} "

  for areaCandidate in "${SERVICES[@]}"
  do
    if [  -d ${areaCandidate} ]; then
    log sidt.sh "-a ${areaCandidate}"
    findStacks ${areaCandidate}
    else
    log "WANING: not suitable ${areaCandidate}"
    fi
  done
  cd ..
}
findServices(){

                      logDivider
  SERVICES=( Dockerfile)
   cd application
  log ""
  log "Available Applications"
  log ""
  for i in Dockerfile.*; do # Whitespace-safe but not recursive.
    SERVICES+=("$i")
  done

  # echo "FOUND: [${SERVICES[*]} "
  for dockerFilename in "${SERVICES[@]}"
  do
    if [ -f "${dockerFilename}" ]; then
    if [  "${dockerFilename}" == "Dockerfile" ]; then

      VALUE="service"
     else
        VALUE=${dockerFilename//Dockerfile\./}
      fi
      log "sidt.sh -m ${VALUE} ${SIDT_PROJECT_NAME}-${VALUE}:${SIDT_VERSION}"

    else
    log "WANING: NOT FOUND: ${dockerFilename}"
    fi
  done
  log                    " "
  log Build all using
  log sidt-helm.sh -m
  cd ..
}

if [ "${MAKE}" -eq "1" ];then
log "Executing Make for all Applications ${THIS_APP_SERVICES[@]}"
for app_name in "${THIS_APP_SERVICES[@]}"
do
  makeApplication  ${app_name}
done
fi

if [ "${TEST}" -eq "1" ];then
log "Executing Tests for all areas ${THIS_APP_AREAS[@]}"
for area_name in "${THIS_APP_AREAS[@]}"
do
  executeStack  ${area_name}
done
fi


if [ "${INFO}" -eq "1" ];then
findServices
findAreas



fi


