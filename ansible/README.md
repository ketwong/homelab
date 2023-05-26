# Guide 

Connection test between container and host
```
ansible-playbook -i inventory.ini test-playbook.yml -e "ansible_user=<username> ansible_password=<password> ansible_host=<ketlaptop_ip_address>"
```
