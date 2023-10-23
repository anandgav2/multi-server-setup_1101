variable "region" {}

variable "ami" {}

variable "instance_type" {
  description = "Type of Instance"
  default     = "r6i.xlarge"
}

variable "server_cnt" {
  description = "This is a variable of type number"
  type        = number
  default     = 2
}

variable "base_hostname" {
  description = "Base hostname pattern (e.g., skuad-abinitio)"
  default     = "skuad-abinitio"
}
