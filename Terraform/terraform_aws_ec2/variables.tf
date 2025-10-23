variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  type        = string
}

variable "public_subnet_id" {
  type        = string
}

variable "instance_type" {
  type        = string
  default     = "t3.medium"
}

variable "allowed_cidr" {
  type        = string
  default     = "0.0.0.0/0"
}


variable "builder_key_filename" {
  type        = string
  default     = "builder_key.pem"
}

variable "ami_owner" {
  type        = string
  default     = "099720109477"
}

variable "ami_name_filter" {
  type        = string
  default     = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
}

