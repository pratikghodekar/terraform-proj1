variable "aws_profile" {
    type = string
}

variable "aws_region" {
    type = string
}

variable "aws_keypair" {
    type = string
}

variable "cidr_block" {
    type = string
}

variable "public_subnet1_cidr" {
    type = string
}

variable "public_subnet2_cidr" {
    type = string
}

variable "private_subnet_cidr" {
    type = string
}

variable "instance_type" {
    type = string
}

variable "public_subnet1_availability_zone" {
    type = string
}

variable "public_subnet2_availability_zone" {
    type = string
}

variable "private_subnet_availability_zone" {
    type = string
}

variable "bucket_name" {
    type = string
}