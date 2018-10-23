variable "number_of_workers" {
    default = 3
}

variable "instance_type" {
    default = "t2.medium"
}

variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

variable "subnet_cidr" {
    default = "10.0.1.0/24"
}
