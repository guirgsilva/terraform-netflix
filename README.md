# DevSecOps Project: Netflix Clone with Jenkins, Docker, and AWS

This project implements a DevSecOps pipeline for a Netflix clone, utilizing Jenkins, Docker, SonarQube, Trivy, and AWS.

## Overview

This project demonstrates the implementation of DevSecOps practices in a Netflix clone environment. It includes:

- Infrastructure as Code using Terraform
- CI/CD pipeline with Jenkins
- Containerization with Docker
- Static code analysis with SonarQube
- Vulnerability scanning with Trivy
- Monitoring with Prometheus and Grafana

## Prerequisites

- AWS Account
- Terraform installed
- Git installed

## Setup

1. Clone this repository:
   ```
   git clone https://github.com/guirgsilva/terraform-netflix.git
   cd terraform-netflix
   ```

2. Configure your AWS credentials:
   ```
   aws configure
   ```

3. Initialize Terraform:
   ```
   terraform init
   ```

4. Apply the Terraform configuration:
   ```
   terraform apply
   ```

## Components

- **EC2 Instances**: Host Jenkins, Docker, SonarQube, and the Netflix Clone application.
- **Jenkins**: Manages the CI/CD pipeline.
- **Docker**: Used for application containerization.
- **SonarQube**: Performs static code analysis.
- **Trivy**: Executes vulnerability scans.
- **Prometheus & Grafana**: Provide monitoring and visualization.

## Usage

After successful deployment:

1. Access Jenkins: `http://<jenkins-ec2-ip>:8080`
2. Access SonarQube: `http://<sonarqube-ec2-ip>:9000`
3. Access Netflix Clone: `http://<app-ec2-ip>:8081`
4. Access Grafana: `http://<grafana-ec2-ip>:3000`

## Pipeline

The Jenkins pipeline includes the following stages:
1. Code checkout
2. Application build
3. Code analysis with SonarQube
4. Vulnerability scanning with Trivy
5. Docker image build and push
6. Deployment to production environment

## Security

- SonarQube performs static code analysis to identify quality and security issues.
- Trivy executes vulnerability scans on Docker images.
- Security practices are integrated throughout the CI/CD pipeline.

## Monitoring

Prometheus and Grafana are used to monitor the application and infrastructure performance and health.

## Contributing

Contributions are welcome! Please read the contribution guidelines before submitting pull requests.

## License

This project is licensed under the [Insert your license here, e.g., MIT License].