variable "aws_region" {
  type    = string
  default = "ap-south-1"
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
  default = "your-keypair-name"  # Replace with your actual key pair
}

variable "my_ip" {
  description = "Your IP address in CIDR format (e.g., 203.0.113.0/32)"
  type        = string
}