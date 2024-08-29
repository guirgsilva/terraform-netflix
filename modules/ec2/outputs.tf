output "docker_jenkins_instance_id" {
  value = aws_instance.netflix_ec2_docker_jenkins.id
}

output "grafana_prometheus_instance_id" {
  value = aws_instance.netflix_ec2_grafana_prometheus.id
}

output "docker_jenkins_public_ip" {
  value = aws_instance.netflix_ec2_docker_jenkins.public_ip
}

output "grafana_prometheus_public_ip" {
  value = aws_instance.netflix_ec2_grafana_prometheus.public_ip
}