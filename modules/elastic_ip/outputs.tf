output "docker_jenkins_public_ip" {
  value = aws_eip.netflix_eip_docker_jenkins.public_ip
}

output "grafana_prometheus_public_ip" {
  value = aws_eip.netflix_eip_grafana_prometheus.public_ip
}