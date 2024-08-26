resource "aws_instance" "netflix_ec2_docker_jenkins" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = true

  user_data = file("${path.module}/user_data_docker_jenkins.sh")

  tags = {
    Name = "netflix-ec2-docker-jenkins"
  }
}

resource "aws_instance" "netflix_ec2_grafana_prometheus" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = true

  user_data = file("${path.module}/user_data_grafana_prometheus.sh")

  tags = {
    Name = "netflix-ec2-grafana-prometheus"
  }
}