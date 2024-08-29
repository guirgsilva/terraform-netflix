output "docker_jenkins_public_ip" {
  description = "Public IP address of the Docker/Jenkins EC2 instance"
  value       = module.elastic_ip.docker_jenkins_public_ip
}

output "grafana_prometheus_public_ip" {
  description = "Public IP address of the Grafana/Prometheus EC2 instance"
  value       = module.elastic_ip.grafana_prometheus_public_ip
}