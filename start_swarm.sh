#!/bin/bash

# vars
[ -z "$NUM_WORKERS" ] && NUM_WORKERS=1
SWARM_MASTER=192.168.8.104
SWARM_WORKER=192.168.8.105

# init swarm (need for service command); if not created
echo "Cleaning up old swarm, if any..."
OLD_SWARM_ID=$(docker info --format "{{.Swarm.NodeID}}")
docker node ls 2> /dev/null | grep "Leader"
if [ $? -ne 1 ]; then
  # kill current swarm
  echo "Killing old swarm: ${OLD_SWARM_ID}"
  docker swarm leave --force > /dev/null 2>&1
  # init new swam
  echo "Initializing new swarm..."
  docker swarm init > /dev/null 2>&1
  else
  # init new swarm
  echo "Initializing new swarm..."
  docker swarm init > /dev/null 2>&1
fi

# get join token
SWARM_TOKEN=$(docker swarm join-token -q worker)

# get Swarm master IP
# SWARM_MASTER=$(docker info --format "{{.Swarm.NodeAddr}}")
echo "Swarm master IP: ${SWARM_MASTER}"
sleep 10

# run NUM_WORKERS workers with SWARM_TOKEN
# get Swarm worker IP
# SWARM_WORKER=$(ssh -o StrictHostKeyChecking=no docker02 "docker info --format "{{.Swarm.NodeAddr}}"")
echo "Swarm worker IP: ${SWARM_WORKER}"
for i in $(seq "${NUM_WORKERS}"); do
  #leave the swarm
  echo "Making worker to leave the old swarm..."
  ssh -o StrictHostKeyChecking=no $SWARM_WORKER "docker swarm leave"
  # add worker container to the swarm
  echo "Adding worker to a new swarm..."
  ssh -o StrictHostKeyChecking=no $SWARM_WORKER "docker swarm join ${SWARM_MASTER}:2377 --token ${SWARM_TOKEN}"
done

# show swarm cluster
printf "\nSwarm Cluster\n===================\n"

docker node ls
