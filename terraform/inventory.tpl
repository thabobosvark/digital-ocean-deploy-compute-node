[head]
${head_private_ip} ansible_user=clusteradmin ansible_ssh_private_key_file=/tmp/ssh_key ansible_become=yes

[compute]
${com1_private_ip} ansible_user=clusteradmin ansible_ssh_private_key_file=/tmp/ssh_key ansible_become=yes
${com2_private_ip} ansible_user=clusteradmin ansible_ssh_private_key_file=/tmp/ssh_key ansible_become=yes

[compute_new]
${com2_private_ip} ansible_user=root ansible_ssh_private_key_file=/tmp/ssh_key

[all:vars]
ansible_python_interpreter=/usr/bin/python3
private_network=10.106.0.0/20
head_private_ip=${head_private_ip}
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
