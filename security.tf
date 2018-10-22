resource "tls_private_key" "internal_key" {
    algorithm = "RSA"
    rsa_bits = 4096
}

resource "aws_key_pair" "auth" {
    key_name = "Default SSH"
    public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "aws_key_pair" "internal_auth" {
    key_name = "Internal Key"
    public_key = "${tls_private_key.internal_key.public_key_openssh}"
}

resource "aws_security_group" "public" {
    name = "Public"
    description = "Allow SSH traffic, HDFS web UI, YARN web UI, internal traffic, and outgoing"
    vpc_id= "${aws_vpc.default.id}"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 50070
        to_port = 50070
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 8088
        to_port = 8088
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["${var.subnet_cidr}"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "private" {
    name = "Private"
    description = "Allow internal traffic and outgoing"
    vpc_id= "${aws_vpc.default.id}"
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["${var.subnet_cidr}"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
