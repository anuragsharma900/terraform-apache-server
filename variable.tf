variable "instance_type" {
type = string
}

variable "key_name" {
type = string
}

variable "ami" {
type = string
}

variable "cidr_block"{
    type = string
}
variable "subnet_prefix"{
    type = list
}

variable "az" {
  type = string
}

variable "allow_all_traffic" {
    type = string
}