provider "aws" {
    region = "us-east-2"
}

resource "aws_vpc" "default" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags {
        Name = "Hadoop Cluster VPC"
    }
}

resource "aws_subnet" "default" {
    vpc_id = "${aws_vpc.default.id}"
    cidr_block = "${var.subnet_cidr}"
    tags {
        Name = "Default Subnet"
    }
}

#resource "aws_subnet" "private" {
#    vpc_id = "${aws_vpc.default.id}"
#    cidr_block = "${var.private_cidr}"
#    tags {
#        Name = "Private Subnet"
#    }
#}

resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.default.id}"
    tags {
        Name = "Internet Gateway"
    }
}

resource "aws_route_table" "internet_access" {
    vpc_id = "${aws_vpc.default.id}"
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }
}

resource "aws_route_table_association" "internet_access" {
    subnet_id = "${aws_subnet.default.id}"
    route_table_id = "${aws_route_table.internet_access.id}"
}
