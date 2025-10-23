output "instance_public_ip" {
  value       = aws_instance.builder.public_ip
}

output "ssh_private_key_path" {
  value       = local_file.private_key.filename
  sensitive   = true
}

output "ssh_key_name" {
  value       = aws_key_pair.builder_key.key_name
}

output "security_group_id" {
  value       = aws_security_group.builder_sg.id
}

output "instance_id" {
  value       = aws_instance.builder.id
}

output "ami_id" {
  value       = data.aws_ami.ubuntu.id
}

