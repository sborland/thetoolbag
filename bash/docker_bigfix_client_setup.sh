#!/usr/bin/env bash

#Script to spin up docker images and containers of various OS with the Bigfix Client (used with Jenkins)
#Reference: https://www.panix.com/~elflord/unix/bash-tute.html

#ROOT_SERVER_ADDRESS=
#OPERATING_SYSTEM=
#NUMBER_OF_CONTAINERS=
#JOB_NAME=
#BUILD_NUMBER=

#Checks if the Bigfix image for that particular server has already been created
check=$(docker images --filter "label=rootServer=${ROOT_SERVER_ADDRESS}" --filter "label=OS=${OPERATING_SYSTEM}" --format "{{.Repository}} | {{.ID}}")
if [ -z check ]; then
    #If not, it pulls the DockerfileTemplate (found in tools repo)
    echo "Image does not exist. Creating Image..."
    curl https://raw.githubusercontent.com/sborland/tools/master/docker/Dockerfiles/bigfix_ubuntu/Dockerfile -o DockerfileTemplate
    #Replaces the sections in the Dockerfile with the OS name and the Bigfix root server addresses and build the image
    sed 's/_OPERATING.SYSTEM_/'"${OPERATING_SYSTEM}"'/g; s/_PUT.YOUR.RELAY.HERE.hostnameORfqdnORip_/'"${ROOT_SERVER_ADDRESS}"'/g' DockerfileTemplate > Dockerfile
    docker build -t ${OPERATING_SYSTEM}_${BIGFIX_SERVER_ADDRESS} .
    if (($?)); then
       echo "Failed to build docker image: ${OPERATING_SYSTEM}_${ROOT_SERVER_ADDRESS}" >&2
       exit 1
    else
       echo "Successfully built docker image: ${OPERATING_SYSTEM}_${ROOT_SERVER_ADDRESS}"
       rm DockerfileTemplate 
       rm Dockerfile
    fi
else
    echo "Image exists. Running container using docker image: ${OPERATING_SYSTEM}_${ROOT_SERVER_ADDRESS}..."
fi
#If the image exists or after the image is built by Docker, spin up as many containers are noted
for (( i=1; i<=${NUMBER_OF_CONTAINERS}; i++))
    do
        docker container run -d -P --init --name="${ROOT_SERVER_ADDRESS}_${OPERATING_SYSTEM}_${JOB_NAME}_${BUILD_NUMBER}_$i" ${OPERATING_SYSTEM}_${BIGFIX_SERVER_ADDRESS}
            if (($?)); then
                echo "Failed to run docker container: ${ROOT_SERVER_ADDRESS}_${OPERATING_SYSTEM}_${JOB_NAME}_${BUILD_NUMBER}_$i"  >&2
                exit 1
            else
                echo "Successfully running docker container: ${ROOT_SERVER_ADDRESS}_${OPERATING_SYSTEM}_${JOB_NAME}_${BUILD_NUMBER}_$i"
            fi
    done
echo "Docker script finished."
exit 0