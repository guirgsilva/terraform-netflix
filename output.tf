# IPs públicos
output "docker_jenkins_public_ip" {
  description = "Public IP address of the Docker/Jenkins EC2 instance"
  value       = module.elastic_ip.docker_jenkins_public_ip
}

output "grafana_prometheus_public_ip" {
  description = "Public IP address of the Grafana/Prometheus EC2 instance"
  value       = module.elastic_ip.grafana_prometheus_public_ip
}

# Endereços dos serviços
output "jenkins_url" {
  description = "URL to access Jenkins"
  value       = "http://${module.elastic_ip.docker_jenkins_public_ip}:8080"
}

output "sonarqube_url" {
  description = "URL to access SonarQube"
  value       = "http://${module.elastic_ip.docker_jenkins_public_ip}:9000"
}

output "netflix_url" {
  description = "URL to access SonarQube"
  value       = "http://${module.elastic_ip.docker_jenkins_public_ip}:8081"
}
output "prometheus_url" {
  description = "URL to access Prometheus"
  value       = "http://${module.elastic_ip.grafana_prometheus_public_ip}:9090"
}

output "grafana_url" {
  description = "URL to access Grafana"
  value       = "http://${module.elastic_ip.grafana_prometheus_public_ip}:3000"
}

# Informações adicionais
output "jenkins_initial_password_command" {
  description = "Command to retrieve the initial admin password for Jenkins"
  value       = "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
}

output "grafana_initial_credentials" {
  description = "Initial login credentials for Grafana"
  value       = "Username: admin, Password: admin (change on first login)"
}

output "ssh_command_jenkins" {
  description = "SSH command to connect to the Jenkins instance"
  value       = "ssh -i <path-to-your-key>.pem ubuntu@${module.elastic_ip.docker_jenkins_public_ip}"
}

output "ssh_command_grafana_prometheus" {
  description = "SSH command to connect to the Grafana/Prometheus instance"
  value       = "ssh -i <path-to-your-key>.pem ubuntu@${module.elastic_ip.grafana_prometheus_public_ip}"
}