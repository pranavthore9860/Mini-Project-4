output "web_url" {
  description = "Public URL of the Nginx web server after Ansible completes."
  value       = "http://${aws_instance.web.public_ip}"
}

output "instance_public_ip" {
  description = "Public IPv4 address used by Ansible."
  value       = aws_instance.web.public_ip
}

output "backup_bucket_name" {
  description = "Name of the private, encrypted, versioned demo backup bucket."
  value       = aws_s3_bucket.backup.id
}
