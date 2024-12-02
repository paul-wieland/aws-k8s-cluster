[${cluster_name}:children]
control_plane
worker

[control_plane]
%{ for instance in control_plane_instances ~}
${instance.host_name} ansible_host=${instance.private_ip} ansible_ssh_common_args='-o ProxyCommand="ssh -i ../keys/ssh_key -W %h:%p -q ${bastion_user}@${bastion_ip}"'
%{ endfor ~}

[worker]
%{ for instance in worker_instances ~}
${instance.host_name} ansible_host=${instance.private_ip} ansible_ssh_common_args='-o ProxyCommand="ssh -i ../keys/ssh_key -W %h:%p -q ${bastion_user}@${bastion_ip}"'
%{ endfor ~}

[all:vars]
ansible_python_interpreter=/usr/bin/python3