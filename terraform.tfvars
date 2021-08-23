instance_type = "t2.micro"
key_name = "jenkin_server"
ami = "ami-0db72f413fc1ddb2a"
cidr_block ="10.0.0.0/16"
subnet_prefix = [{cidr = "10.0.1.0/24", name="dev-subnet"},{cidr = "10.0.2.0/24", name = "prod-subnet"}]
az ="ca-central-1a"
allow_all_traffic = "0.0.0.0/0"