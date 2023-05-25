FROM ubuntu:latest

# Set non-interactive environment variable for geographic area
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y openssh-server nano

# Install Ansible and other dependencies
RUN apt-get install -y software-properties-common
RUN apt-add-repository --yes --update ppa:ansible/ansible
RUN apt-get install -y ansible python3-pip

# Install pywinrm for Windows communication
RUN pip3 install pywinrm

# Configure SSH server
RUN echo 'root:root' | chpasswd
RUN sed 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' -i /etc/ssh/sshd_config
RUN service ssh start

CMD ["/bin/bash"]
