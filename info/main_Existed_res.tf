/* S3 Bucket Creation Logic

resource "aws_s3_bucket" "terra_state" {
    bucket = "anurag-balty"
    versioning {
      enabled = true
    }
    server_side_encryption_configuration {
      rule{
          apply_server_side_encryption_by_default {
              sse_algorithm = "AES256"
          }
      }
    }


}*/

# joining the backend
terraform {
backend "s3" {
bucket = "anurag-balty"
key = "terraform/terraform.tfstate"
region= "ca-central-1"
}
}

data "aws_vpc" "first-vpc-central-canada"{
filter {
name = "tag:Name"
values =["first-vpc-central-canada"]
}
}

data "aws_subnet" "first-vpc-subnet-1"{
vpc_id = data.aws_vpc.first-vpc-central-canada.id
filter {
name = "tag:Name"
values = ["first-vpc-subnet-1"]
}
}

data "aws_security_group" "first-vpc-sub1-ec1-SG1"{
vpc_id = data.aws_vpc.first-vpc-central-canada.id
filter {
name = "tag:Name"
values = ["first-vpc-sub1-ec1-SG1"]
}
}

resource "aws_instance" "ansible_server"{
ami= var.ami
instance_type = var.instance_type
subnet_id = data.aws_subnet.first-vpc-subnet-1.id
vpc_security_group_ids = [data.aws_security_group.first-vpc-sub1-ec1-SG1.id]
key_name ="ubuntu_instance_key"
tags= {
Name = "ansible_server"
}
}