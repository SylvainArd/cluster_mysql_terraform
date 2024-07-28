output "db_cluster_endpoint" {
  description = "The endpoint of the Aurora DB cluster"
  value       = aws_rds_cluster.aurora_cluster.endpoint
}

output "db_reader_endpoint" {
  description = "The reader endpoint of the Aurora DB cluster"
  value       = aws_rds_cluster.aurora_cluster.reader_endpoint
}

output "ec2_instance_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.web.public_ip
}


