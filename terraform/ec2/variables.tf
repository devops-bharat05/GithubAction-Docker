variable "aws_region" {
  type    = string
  default = "us-east-1"  # Replace with your desired AWS region
}

variable "aws_access_key" {
  type      = string
  sensitive = true
}

variable "aws_secret_key" {
  type      = string
  sensitive = true
}

variable "key_name" {
  type    = string
  default = "my-key-pair"  # Replace with your actual key pair
}

