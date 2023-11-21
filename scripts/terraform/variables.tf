variable "region" {
  description = "AWS region"
  default = "ap-south-1"
}

variable "ami" {
  description = "Type of OS"
  default = "ami-05c8ca4485f8b138a"
}

variable "instance_type" {
  description = "Type of Instance"
  default     = "r6i.2xlarge"
}

variable "host_alias_path" {
  type    = string
  default = "./host_alias.txt"
}