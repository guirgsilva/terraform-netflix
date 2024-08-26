resource "aws_eip" "netflix_eip_docker_jenkins" {
  instance = var.docker_jenkins_instance_id
  vpc      = true

  tags = {
    Name = "netflix-eip-docker-jenkins"
  }
}

resource "aws_eip" "netflix_eip_grafana_prometheus" {
  instance = var.grafana_prometheus_instance_id
  vpc      = true

  tags = {
    Name = "netflix-eip-grafana-prometheus"
  }
}