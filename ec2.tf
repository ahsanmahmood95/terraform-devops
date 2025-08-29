#key pairs
resource "aws_key_pair" "my-key_aws" {
    key_name = "terra-key"
    public_key = file("terra-ec2-key.pub")
  
}

# VPC and security group
resource "aws_default_vpc" "default" {
  
}

resource "aws_security_group" "my_security_group" {
    name = "alpha-group"
    description = "security-group"
    vpc_id = aws_default_vpc.default.id

    #inbound rules
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "ssh"
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "http"
    }

    #outbound rules
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "open to all outbounds"
    }
    tags = {
      Name = "alpha-group"
    }
  
}

#ec2 instance

resource "aws_instance" "my_instance" {
#  count = 2  # meta argument will create 2 instances with same names
    for_each = tomap({
      terra-practice-1 = "t3.micro"
    })

    depends_on = [ aws_security_group.my_security_group, aws_key_pair.my-key_aws ]

    key_name = aws_key_pair.my-key_aws.key_name
    security_groups = [aws_security_group.my_security_group.name]
    instance_type = each.value
    ami = var.ec2_ami_id
    user_data = file("install_nginx.sh")
    root_block_device {
      volume_size = var.env == "prd" ? 20 : var.ec2_default_root_storage_size
      volume_type = "gp3"
    }
    tags = {
      Name = each.key
      enviornment = var.env
    }
  
}
# to import a manually created ec2 instance from aws to terraform
/* 
resource "aws_instance" "my_new_instance" {
  instance_type = "unknown"
  ami = "unknown"
} */