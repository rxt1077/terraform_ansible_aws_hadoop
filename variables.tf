variable "number_of_workers" {
    default = 1
}

variable "instance_type" {
    default = "t2.micro"
}

variable "hadoop_version" {
    default = "3.1.1"
}

variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

variable "subnet_cidr" {
    default = "10.0.1.0/24"
}

#variable "private_cidr" {
#    default = "10.0.2.0/24"
#}
