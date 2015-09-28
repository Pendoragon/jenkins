FROM jenkins
MAINTAINER Pengcheng Tang <tupachydralisk@gmail.com>

COPY config.xml /var/jenkins_home/

# Run the following commands as "root" so that we will be able
# to add "jenkins" to docker group
USER root

# Set up the plugins we need
COPY active.txt /usr/share/jenkins/active.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/active.txt

# Set up the env and run jenkins as user "jenkins"
COPY setup-n-run.sh /
ENTRYPOINT ["/setup-n-run.sh"]
