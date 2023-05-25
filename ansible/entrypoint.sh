#!/bin/bash

# Generate Ansible configuration
echo -e "[defaults]\n\
host_key_checking = False\n\
\n\
[winrm]\n\
ansible_user = $ANSIBLE_USER\n\
ansible_password = $ANSIBLE_PASSWORD\n\
ansible_port = 5986\n\
ansible_connection = winrm\n\
ansible_winrm_scheme = https\n\
ansible_winrm_server_cert_validation = ignore\n\
ansible_winrm_transport = ntlm" > /etc/ansible/ansible.cfg

exec "$@"
