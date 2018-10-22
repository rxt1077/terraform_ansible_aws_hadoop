# Terraform / Ansible AWS Hadoop Cluster

This project sets up a [Hadoop](https://hadoop.apache.org) Cluster on
[AWS](https://aws.amazon.com) using [Terraform](https://www.terraform.io) and
[Ansible](https://www.ansible.com).

A virtual private cloud, subnet, security groups, keys, internet gateway,
master node and worker nodes are setup using Terraform. Ansible is then used on
the master node to setup Hadoop.

This diagram details the architecture:

![AWS Architecture Diagram](https://github.com/rxt1077/terraform_ansible_aws_hadoop/blob/master/diagrams/diagram.png "AWS Architecture Diagram")
