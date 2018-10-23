# Terraform / Ansible AWS Hadoop Cluster

## Overview

This project sets up a [Hadoop](https://hadoop.apache.org) cluster on
[AWS](https://aws.amazon.com) using [Terraform](https://www.terraform.io) and
[Ansible](https://www.ansible.com).

A virtual private cloud, subnet, security groups, keys, internet gateway,
master node and worker nodes are setup using Terraform. Ansible is then used on
the master node to setup Hadoop.

This diagram details the architecture:

![AWS Architecture Diagram](https://github.com/rxt1077/terraform_ansible_aws_hadoop/blob/master/diagrams/diagram.png "AWS Architecture Diagram")

## Setup

* *variables.tf* - contains the number of workers and the instance type. It is
currently set to three workers and t2.large respectively.
* *~/.ssh/id_rsa* - your default SSH key will be used to connect to the master
node.
* *~/.aws/credentials* - your AWS credentials have to be setup with full
access for Terraform to construct the cluster.

## Running

Clone the repository, initialize terraform, apply terraform, and ssh into the
public ip. Terraform will create all of the instances and setup enough
configuration to bootstrap Ansible on master. It will then run the Ansible
playbook on master to finish the configuration. Finally it prints out the
public_ip of master so you can SSH into it.
```bash
git clone https://github.com/rxt1077/terraform_ansible_aws_hadoop.git
terraform init
terraform apply
ssh ec2-user@<public_ip>
```
