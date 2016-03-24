FROM jenkins:1.609.3
MAINTAINER Pengcheng Tang <tupachydralisk@gmail.com>

# Set up the plugins we need
COPY active.txt /usr/share/jenkins/active.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/active.txt
