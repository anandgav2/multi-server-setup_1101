variable "region" {}

variable "ami" {}

variable "instance_type" {
  description = "Type of Instance"
  default     = "r6i.2xlarge"
}

variable "server_cnt" {
  description = "This is a variable of type number"
  type        = number
  default     = 1
}
