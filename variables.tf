variable "ec2_instance_type" {
    default = "t3.micro"
    type = string 
}
variable "ec2_default_root_storage_size" {
    default = 10
    type = number  
}
variable "ec2_ami_id" {
    default = "ami-0360c520857e3138f"
    type = string
}

#to add condition if enviornment is dev
variable "env" {
    default = "prd"
    type = string
}