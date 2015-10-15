#!/bin/bash
set -e

JUSER="jenkins"

# /var/run/docker.sock is a bind mount from host
DOCKER_GID=$(ls -aln /var/run/docker.sock  | awk '{print $4}')

if ! getent group $DOCKER_GID; then
	echo creating docker group $DOCKER_GID
	addgroup --gid $DOCKER_GID docker
fi

DOCKER_GROUP=$(ls -al /var/run/docker.sock  | awk '{print $4}')
if ! id -nG "$JUSER" | grep -qw "$DOCKER_GROUP"; then
	adduser $JUSER $DOCKER_GROUP
fi

chown -R $JUSER:$JUSER /var/jenkins_home/
chown -R $JUSER:$JUSER /var/log/jenkins/

exec su $JUSER -c "/usr/local/bin/jenkins.sh"
