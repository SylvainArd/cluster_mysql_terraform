variable "region" {
  description = "The AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "db_cluster_identifier" {
  description = "The identifier for the Aurora DB cluster"
  type        = string
  default     = "aurora-cluster"
}

variable "db_name" {
  description = "The name of the database in the Aurora cluster"
  type        = string
  default     = "mydatabase"
}

variable "db_user" {
  description = "The master username for the database"
  type        = string
  default     = "myuser"
}

variable "db_password" {
  description = "The master password for the database"
  type        = string
  default     = "mypassword"
  sensitive   = true
}

variable "instance_class" {
  description = "The instance class for the Aurora instances"
  type        = string
  default     = "db.t3.medium"
}

variable "vpc_id" {
  description = "The ID of the VPC where the Aurora cluster will be created"
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs for the Aurora cluster"
  type        = list(string)
}

variable "subnet_id" {
  description = "The ID of the subnet for the EC2 instance"
  type        = string
}

variable "key_name" {
  description = "The name of the SSH key pair"
  type        = string
}

variable "ami_id" {
  description = "The ID of the AMI to use for the EC2 instance"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"  # Default to Amazon Linux 2 AMI
}


variable "public_key" {
  description = "The SSH public key"
  type        = string
}