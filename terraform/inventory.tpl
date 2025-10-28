[head]
${head_private_ip} ansible_user=root ansible_ssh_private_key_file=~/.ssh/id_ed25519

[compute]
${com1_private_ip} ansible_user=root ansible_ssh_private_key_file=~/.ssh/id_ed25519
${com2_private_ip} ansible_user=root ansible_ssh_private_key_file=~/.ssh/id_ed25519

[all:vars]
ansible_python_interpreter=/usr/bin/python3
private_network=10.106.0.0/20
head_private_ip=${head_private_ip}
