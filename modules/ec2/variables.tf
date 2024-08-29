variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance"
}

variable "instance_type" {
  description = "The instance type for the EC2 instance"
}

variable "key_name" {
  description = "The key pair name for the EC2 instance"
}
variable "public_subnet_id" {
  type        = string
  description = "The ID of the public subnet where the EC2 instance will be launched"
}
variable "security_group_id" {
  type        = string
  description = "The ID of the security group where the EC2 instance will be launched"
}
variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where the EC2 instance will be launched"
}