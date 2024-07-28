resource "aws_rds_cluster_parameter_group" "aurora_parameters" {
  name   = "aurora-cluster-params"
  family = "aurora-mysql5.7"

  parameter {
    name  = "init_connect"
    value = "CREATE TABLE IF NOT EXISTS exemple (exemple VARCHAR(255));"
  }
}

resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier      = var.db_cluster_identifier
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.08.1"
  master_username         = var.db_user
  master_password         = var.db_password
  database_name           = var.db_name
  backup_retention_period = 7
  preferred_backup_window = "07:00-09:00"
  skip_final_snapshot     = true
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_parameters.id
  vpc_security_group_ids  = [aws_security_group.db_sg.id]

  depends_on = [aws_rds_subnet_group.aurora_subnet_group]
}

resource "aws_rds_cluster_instance" "aurora_instances" {
  count               = 2
  identifier          = "${var.db_cluster_identifier}-instance-${count.index + 1}"
  cluster_identifier  = aws_rds_cluster.aurora_cluster.id
  instance_class      = var.instance_class
  engine              = aws_rds_cluster.aurora_cluster.engine
  engine_version      = aws_rds_cluster.aurora_cluster.engine_version
  publicly_accessible = true

  depends_on = [aws_rds_cluster.aurora_cluster]
}

resource "aws_security_group" "db_sg" {
  name        = "aurora-sg"
  description = "Allow MySQL inbound traffic"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = var.vpc_id
}

resource "aws_rds_subnet_group" "aurora_subnet_group" {
  name       = "aurora-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  subnet_id     = var.subnet_id

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y php php-mysqlnd httpd mariadb-server
              sudo systemctl start httpd
              sudo systemctl enable httpd
              sudo chown -R ec2-user:ec2-user /var/www/html
              sudo chmod -R 755 /var/www/html
              EOF

  tags = {
    Name = "WebServer"
  }
}

resource "aws_security_group" "web_sg" {
  name        = "allow-web"
  description = "Allow web traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = var.vpc_id
}
