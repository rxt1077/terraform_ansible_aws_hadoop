# Terraform / Ansible AWS Hadoop Cluster

This project sets up a Hadoop Cluster on AWS using Terraform and Ansible. A
master node and several worker nodes are setup using the Amazon Linux AMI.
Within the virtual private cloud the workers are on a private subnet and the
master is on a public subnet. The public subnet can connect to the internet and
receive SSH connections. The default ssh key on the host running Terraform is
used to connect to the master. The master node then uses Ansible to configure
itself and the workers.
