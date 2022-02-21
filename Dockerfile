FROM ubuntu:18.04
MAINTAINER oshima
#ref:https://docs.aws.amazon.com/ja_jp/cloud9/latest/user-guide/sample-docker.html#sample-docker-install

ENV TZ Asia/Tokyo \
    LC_ALL en_US.UTF-8 \
    LANG en_US.UTF-8


###[ CLOUD9 installation ]######################################################

#install common tools
RUN apt update -y
RUN apt install -y sudo bash curl wget git man-db nano vim bash-completion
##tumx start
RUN apt install -y locales-all
RUN apt install -y git automake bison build-essential pkg-config libevent-dev
RUN apt install -y libncurses5-dev
RUN git clone https://github.com/tmux/tmux /usr/local/src/tmux && \
    cd /usr/local/src/tmux && \
    ./autogen.sh && \
    ./configure --prefix=/usr/local && \
    make && \
    make install 
##tumx end
RUN apt install -y gcc
RUN apt install -y build-essential
RUN apt install -y make tar
RUN apt install -y python

#Enable the Docker container to communicate with AWS Cloud9
# by installing SSH.
RUN apt install -y openssh-server

#Ensure nodejs installed.
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
RUN apt-get install -y nodejs

#Ensure that Python3+debug is installed.
RUN apt install -y python3
RUN apt install -y python3-pip     
#RUN apt install python3.6-dev     
RUN pip3 install ikp3db

#Create user(ubuntu) and enable root access
#ref:https://kawairi.jp/weblog/vita/2016040220277
RUN adduser ubuntu && \
    sed -i -e '/sufficient pam_wheel.so trust/a\auth sufficient pam_wheel.so trust group=wheel' /etc/pam.d/su && \
    sed -i -e '/Members of the admin group may gain root privileges/a\%wheel ALL=(ALL) NOPASSWD:ALL' /etc/sudoers && \ 
    addgroup wheel && \
    usermod -aG wheel ubuntu

# Add the AWS Cloud9 SSH public key to the Docker container.
# This assumes a file named authorized_keys containing the
# AWS Cloud9 SSH public key already exists in the same
# directory as the Dockerfile.
RUN mkdir -p /home/ubuntu/.ssh
ADD ./authorized_keys /home/ubuntu/.ssh/authorized_keys
RUN chown -R ubuntu /home/ubuntu/.ssh /home/ubuntu/.ssh/authorized_keys && \
chmod 700 /home/ubuntu/.ssh && \
chmod 600 /home/ubuntu/.ssh/authorized_keys

# Update the password to a random one for the user ubuntu.
RUN echo "ubuntu:$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)" | chpasswd

# pre-install Cloud9 dependencies
USER ubuntu
RUN curl https://d2j6vhu5uywtq3.cloudfront.net/static/c9-install.sh | bash

USER root
# Start SSH in the Docker container.
RUN mkdir -p /run/sshd
CMD ssh-keygen -A && /usr/sbin/sshd -D

#sample app install
COPY ./sample/python/server.py /home/ubuntu/
RUN pip3 install flask

# directory auth
RUN chown -R ubuntu:ubuntu /home/ubuntu

