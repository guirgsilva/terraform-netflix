# DevSecOps Project: Netflix Clone com Jenkins, Docker e AWS

Este projeto implementa um pipeline DevSecOps para um clone do Netflix, utilizando Jenkins, Docker, SonarQube, Trivy e AWS.

## Visão Geral

Este projeto demonstra a implementação de práticas DevSecOps em um ambiente de clone do Netflix. Ele inclui:

- Infraestrutura como código usando Terraform
- Pipeline de CI/CD com Jenkins
- Containerização com Docker
- Análise de código estático com SonarQube
- Varredura de vulnerabilidades com Trivy
- Monitoramento com Prometheus e Grafana

## Pré-requisitos

- Conta AWS
- Terraform instalado
- Git instalado

## Configuração

1. Clone este repositório:
   ```
   git clone https://github.com/seu-usuario/seu-repositorio.git
   cd seu-repositorio
   ```

2. Configure suas credenciais AWS:
   ```
   aws configure
   ```

3. Inicialize o Terraform:
   ```
   terraform init
   ```

4. Aplique a configuração do Terraform:
   ```
   terraform apply
   ```

## Componentes

- **EC2 Instances**: Hospedam Jenkins, Docker, SonarQube e o aplicativo Netflix Clone.
- **Jenkins**: Gerencia o pipeline de CI/CD.
- **Docker**: Utilizado para containerização do aplicativo.
- **SonarQube**: Realiza análise de código estático.
- **Trivy**: Executa varreduras de vulnerabilidades.
- **Prometheus & Grafana**: Fornecem monitoramento e visualização.

## Uso

Após a implantação bem-sucedida:

1. Acesse Jenkins: `http://<jenkins-ec2-ip>:8080`
2. Acesse SonarQube: `http://<sonarqube-ec2-ip>:9000`
3. Acesse o Netflix Clone: `http://<app-ec2-ip>:8081`
4. Acesse Grafana: `http://<grafana-ec2-ip>:3000`

## Pipeline

O pipeline Jenkins inclui as seguintes etapas:
1. Checkout do código
2. Construção do aplicativo
3. Análise de código com SonarQube
4. Varredura de vulnerabilidades com Trivy
5. Construção e push da imagem Docker
6. Implantação no ambiente de produção

## Segurança

- SonarQube realiza análises de código estático para identificar problemas de qualidade e segurança.
- Trivy executa varreduras de vulnerabilidades em imagens Docker.
- As práticas de segurança são integradas em todo o pipeline de CI/CD.

## Monitoramento

Prometheus e Grafana são utilizados para monitorar o desempenho e a saúde da aplicação e da infraestrutura.

## Contribuindo

Contribuições são bem-vindas! Por favor, leia as diretrizes de contribuição antes de submeter pull requests.

## Licença

Este projeto está licenciado sob a [Inserir sua licença aqui, por exemplo, MIT License].