variable "region" {}

variable "ami" {}

variable "instance_type" {
  description = "Type of Instance"
  default     = "r6i.2xlarge"
}