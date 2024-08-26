output "docker_jenkins_instance_id" {
  value = aws_instance.netflix_ec2_docker_jenkins.id
}

output "grafana_prometheus_instance_id" {
  value = aws_instance.netflix_ec2_grafana_prometheus.id
}