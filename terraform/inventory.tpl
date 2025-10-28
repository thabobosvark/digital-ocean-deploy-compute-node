[head]
${head_ip}

[com1]
${com1_ip}

[com2]
${com2_ip}

[compute_nodes]
${com1_ip}
${com2_ip}

[all:vars]
ansible_user=root
ansible_ssh_private_key_file=/tmp/ssh_key
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
