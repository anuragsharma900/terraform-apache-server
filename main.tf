#1 create vpc
resource "aws_vpc" "terraform-vpc" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "terraform-vpc"
  }
}

#2 Create Internet Gateway
resource "aws_internet_gateway" "terraform-gw" {
  vpc_id = aws_vpc.terraform-vpc.id

  tags = {
    Name = "terraform-gw"
  }
}

#3 create Route Table
resource "aws_route_table" "terraform-routetable" {
  vpc_id = aws_vpc.terraform-vpc.id

  route = [
      {
        cidr_block = var.allow_all_traffic
        gateway_id = aws_internet_gateway.terraform-gw.id
        "carrier_gateway_id" = null
        "destination_prefix_list_id"= null
        "egress_only_gateway_id" = null
    "instance_id" = null
    "ipv6_cidr_block" = null
    "local_gateway_id" = null
    "nat_gateway_id" = null
    "network_interface_id"= null
    "transit_gateway_id" = null
    "vpc_endpoint_id"= null
    "vpc_peering_connection_id"= null
    }]
  
  tags = {
    Name = "terraform-routetable"
  }
}

#4 create Subnet 
resource "aws_subnet" "terraform-subnet" {
  vpc_id     = aws_vpc.terraform-vpc.id
  cidr_block = var.subnet_prefix[0].cidr
  availability_zone = var.az
  tags = {
    Name = var.subnet_prefix[0].name
  }
}

#5 Associate subnet with Route Table
resource "aws_route_table_association" "assoRT" {
  subnet_id      = aws_subnet.terraform-subnet.id
  route_table_id = aws_route_table.terraform-routetable.id
}

#6 create Security Group
resource "aws_security_group" "terraform-allow-ports" {
  name        = "terraform-allow-ports"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.terraform-vpc.id

  ingress = [
    {
      description      = "http from VPC"
      from_port        = 80
      to_port          = 80
      "ipv6_cidr_blocks": null,
      "prefix_list_ids": null, 
      "protocol": "tcp",
      "security_groups": null,
       self: null,
      cidr_blocks      = ["0.0.0.0/0"]
      
    },
    {
      description      = "https from VPC"
      from_port        = 443
      to_port          = 443
      "ipv6_cidr_blocks": null,
      "prefix_list_ids": null, 
      "protocol": "tcp",
      "security_groups": null,
       self: null,
      cidr_blocks      = ["0.0.0.0/0"]
      
    },
    {
      description      = "ssh from VPC"
      from_port        = 22
      to_port          = 22
      "ipv6_cidr_blocks": null,
      "prefix_list_ids": null, 
      "protocol": "tcp",
      "security_groups": null,
       self: null,
       cidr_blocks      = ["0.0.0.0/0"]
      
    }
  ]
  egress = [{
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      description =null
      prefix_list_ids =null
      security_groups = null
      self = null

    }]

  tags = {
    Name = "terraform-allow-ports"
  }
}

#7 create network interface
resource "aws_network_interface" "terraform-nic" {
  subnet_id       = aws_subnet.terraform-subnet.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.terraform-allow-ports.id]

}

#8 Assign Elastic IP with NIC
resource "aws_eip" "eip-nic" {
  vpc                       = true
  network_interface         = aws_network_interface.terraform-nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on = [
    aws_internet_gateway.terraform-gw
  ]
}

#9 create aws instance webserver Ubuntu
resource "aws_instance" "terraform_apache-server"{
ami= var.ami
instance_type = var.instance_type
availability_zone = var.az
key_name ="instance_key"
network_interface {
  network_interface_id = aws_network_interface.terraform-nic.id
  device_index = 0
}
user_data = <<-EOF
            #!/bin/bash
            sudo yum update -y
            sudo yum install httpd.x86_64 -y
            sudo systemctl start httpd.service
            sudo systemctl enable httpd.service
            echo "This is Anurag's terraform tutorial" > /var/www/html/index.html
            EOF


tags= {
Name = "terraform_server"
}
}
