variable "aws_region" {
  description = "AWS region used for all resources. Keep this aligned with backend.tf."
  type        = string
  default     = "us-east-1"
}

variable "ssh_allowed_cidr" {
  description = "Single trusted IPv4 CIDR allowed to SSH to the instance, such as 203.0.113.7/32."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.ssh_allowed_cidr))
    error_message = "ssh_allowed_cidr must be a valid IPv4 CIDR. Use your public IP with /32."
  }
}

variable "ec2_ssh_public_key" {
  description = "Public half of the SSH key pair used by Ansible. Keep the private key out of Git."
  type        = string
  sensitive   = true
}
