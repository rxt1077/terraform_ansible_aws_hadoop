# Our master instance with everything we need to use ansible
resource "aws_instance" "master" {
    ami = "ami-0b59bfac6be064b78"
    instance_type = "${var.instance_type}"
    vpc_security_group_ids = ["${aws_security_group.public.id}"]
    key_name = "Default SSH"
    subnet_id = "${aws_subnet.default.id}"
    associate_public_ip_address = true
    # Use our local ssh key to connect to the master
    connection {
        type = "ssh"
        user = "ec2-user"
        private_key = "${file("~/.ssh/id_rsa")}"
    }
    # Create a new tar archive each time incase we changed something
    provisioner "local-exec" {
        command = "tar zcf hadoop-configs.tar.gz hadoop"
    }
    # Get the master able to run Ansible
    provisioner "remote-exec" {
        inline = [
            # Install ansible on master
            "sudo yum-config-manager --enable epel",
            "sudo yum -y install ansible",
            # Keep ansible from verifying the identity of our workers
            "sudo sh -c 'sed -i.bak s/#host_key_checking/host_key_checking/ /etc/ansible/ansible.cfg'",
            # Put the internal key we created on master and make sure we can
            # connect to ourselves
            "echo \"${tls_private_key.internal_key.public_key_openssh}\" | tee -a ~/.ssh/authorized_keys > ~/.ssh/id_rsa.pub",
            "echo \"${tls_private_key.internal_key.private_key_pem}\" > ~/.ssh/id_rsa",
            "chmod 600 ~/.ssh/id_rsa",
            # Setup our /etc/hosts on master
            "sudo sh -c 'echo \"${self.private_ip} master\" >> /etc/hosts'",
            "sudo sh -c 'echo \"${join("\n", data.template_file.worker_hosts.*.rendered)}\" >> /etc/hosts'",
            # Setup our /etc/ansible/hosts on master
            "sudo sh -c 'echo \"${data.template_file.ansible_hosts.rendered}\" > /etc/ansible/hosts'",
            # Setup our /home/ec2-user/hadoop/etc/hadoop/workers on master
            "mkdir -p ~/hadoop/etc/hadoop",
            "echo \"${data.template_file.hadoop_workers.rendered}\" > ~/hadoop/etc/hadoop/workers",
        ]
    }
    # This is the Ansible playbook that configures Hadoop on the master and
    # workers
    provisioner "file" {
        source = "playbook.yml"
        destination = "playbook.yml"
    }
    # These are all the Hadoop config files we use (except etc/hadoop/workers
    # which is generated in Terrform)
    provisioner "file" {
        source = "hadoop-configs.tar.gz"
        destination = "hadoop-configs.tar.gz"
    }
    tags {
        Name = "Hadoop Master"
    }
}

# Our worker instance with an internal key
resource "aws_instance" "worker" {
    count = "${var.number_of_workers}"
    ami = "ami-0b59bfac6be064b78"
    instance_type = "${var.instance_type}"
    vpc_security_group_ids = ["${aws_security_group.private.id}"]
    key_name = "${aws_key_pair.internal_auth.key_name}"
    subnet_id = "${aws_subnet.default.id}"
    associate_public_ip_address = true
    tags {
        Name = "Hadoop Worker ${count.index}"
    }
}
