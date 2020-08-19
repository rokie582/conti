variable "AWS_REGION" {
  default = "eu-central-1"
}

variable "AMIS" {
  type = "map"
  default = {
    eu-central-1 = "ami-0c115dbd34c69a004"
  }
}