# A list of worker ips and names that gets appended to the /etc/hosts file. We
# can't do the  whole thing in one shot because our master resource would end
# up referencing itself to get its IP, but we can use "self" in the provisioner
data "template_file" "worker_hosts" {
    count = "${var.number_of_workers}"
    template = "$${ip} worker$${index}"
    vars = {
        index = "${count.index + 1}"
        ip = "${element(aws_instance.worker.*.private_ip, count.index)}"
    }
}

# A list of worker names
data "template_file" "workers_list" {
    count = "${var.number_of_workers}"
    template = "worker$${index}"
    vars = {
        index = "${count.index + 1}"
    }
}

# Worker names in a string with newlines
data "template_file" "workers" {
    template = "$${worker_names}"
    vars = {
        worker_names = "${join("\n", data.template_file.workers_list.*.rendered)}"
    }
}

# Ansible intentory file rendered as a string
data "template_file" "ansible_hosts" {
    template = <<EOF
[masters]
master

[workers]
$${workers}
EOF
    vars = {
        workers = "${data.template_file.workers.rendered}"
    }
}

# Hadoop workers file rendered as a string
data "template_file" "hadoop_workers" {
    template = "$${workers}"
    vars = {
        workers = "${data.template_file.workers.rendered}"
    }
}
