FROM jenkins:1.609.3
MAINTAINER Pengcheng Tang <tupachydralisk@gmail.com>

# Set up the plugins we need
COPY active.txt /usr/share/jenkins/active.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/active.txt

# Run the following commands as "root" so that we will be able
# to add "jenkins" to docker group
USER root

RUN mkdir /var/log/jenkins

###############################################################################
#            install binaries we need to build our components                 #
###############################################################################
RUN apt-get update && apt-get install -y \
    lxc \
    golang \
    rsync \
    npm \
    expect \
    build-essential \
    ruby-full && \
    gem install compass && \
    npm install --global gulp && npm install --global bower && npm cache clean

# On ubuntu nodejs is by default in /usr/bin/nodejs
RUN ln -s "$(which nodejs)" /usr/bin/node
###############################################################################

ENV JENKINS_OPTS="--handlerCountStartup=100 --handlerCountMax=300 --logfile=/var/log/jenkins/jenkins.log"

# Set up the env and run jenkins as user "jenkins"
COPY setup-n-run.sh /

# Have to use /bin/tini to run the script, otherwise jenkins
# will crash on setting up git repos. Reason is still unknown.
ENTRYPOINT ["/bin/tini", "--", "/setup-n-run.sh"]
