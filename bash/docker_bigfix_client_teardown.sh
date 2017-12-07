#!/usr/bin/env bash

#Script to teardown containers of Bigfix Client (used with Jenkins)
#Reference: https://www.panix.com/~elflord/unix/bash-tute.html

#ROOT_SERVER_ADDRESS=
#OPERATING_SYSTEM=

id=$(docker ps --filter "name=${ROOT_SERVER_ADDRESS}_${OPERATING_SYSTEM}" --format "{{.ID}}" 2>&1 | sed q)
while [ -z != $id ]
do
      echo "Killing container id: "; docker kill $id
      id=$(docker ps --filter "name=${ROOT_SERVER_ADDRESS}_${OPERATING_SYSTEM}" --format "{{.ID}}" 2>&1 | sed q)
done
