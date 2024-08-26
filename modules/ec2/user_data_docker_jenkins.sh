#!/bin/bash

# Função para log
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a /var/log/user_data.log
}

# Função para executar comandos e registrar logs
run_and_log() {
    log "Executando: $1"
    eval $1
    if [ $? -eq 0 ]; then
        log "Comando executado com sucesso: $1"
    else
        log "Erro ao executar: $1"
    fi
}

log "Iniciando script de configuração"

# Atualizar pacotes
run_and_log "sudo apt-get update"
run_and_log "sudo apt-get upgrade -y"

# Instalar dependências
run_and_log "sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common git"

# Instalar Docker
log "Instalando Docker"
run_and_log "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg"
run_and_log "echo \"deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null"
run_and_log "sudo apt-get update"
run_and_log "sudo apt-get install -y docker-ce docker-ce-cli containerd.io"
run_and_log "sudo usermod -aG docker ubuntu"
run_and_log "sudo systemctl enable docker"
run_and_log "sudo systemctl start docker"

# Instalar Java
log "Instalando Java"
run_and_log "sudo apt-get install -y openjdk-11-jdk"

# Instalar Jenkins
log "Instalando Jenkins"
run_and_log "curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null"
run_and_log "echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null"
run_and_log "sudo apt-get update"
run_and_log "sudo apt-get install -y jenkins"
run_and_log "sudo systemctl start jenkins"
run_and_log "sudo systemctl enable jenkins"

# Imprimir a senha inicial do Jenkins
log "Senha inicial do Jenkins:"
run_and_log "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"

# Criar container para SonarQube
log "Criando container para SonarQube"
run_and_log "sudo docker run -d --name sonarqube -p 9000:9000 -p 9092:9092 sonarqube:lts"

# Clonar o repositório Netflix
log "Clonando o repositório Netflix"
run_and_log "git clone https://github.com/N4si/DevSecOps-Project.git"
run_and_log "cd DevSecOps-Project"

# Criar container para Netflix
log "Criando container para Netflix"
run_and_log "sudo docker build --build-arg TMDB_V3_API_KEY=69f97abb81b78cb1ed303b9ff3187fec -t netflix ."
run_and_log "sudo docker run -d --name netflix -p 8081:80 netflix:latest"

# Instalar Trivy
log "Instalando Trivy"
run_and_log "sudo apt-get install -y wget apt-transport-https gnupg lsb-release"
run_and_log "wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo gpg --dearmor -o /usr/share/keyrings/trivy-archive-keyring.gpg"
run_and_log "echo \"deb [signed-by=/usr/share/keyrings/trivy-archive-keyring.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main\" | sudo tee /etc/apt/sources.list.d/trivy.list > /dev/null"
run_and_log "sudo apt-get update"
run_and_log "sudo apt-get install -y trivy"

# Configurar Trivy
log "Configurando Trivy"
run_and_log "sudo mkdir -p /var/trivy"
run_and_log "echo '#!/bin/bash
trivy filesystem --format json --output /var/trivy/results.json /' | sudo tee /usr/local/bin/run-trivy.sh"
run_and_log "sudo chmod +x /usr/local/bin/run-trivy.sh"
run_and_log "(crontab -l 2>/dev/null; echo \"0 0 * * * /usr/local/bin/run-trivy.sh\") | crontab -"

log "Verificando status final"
run_and_log "sudo systemctl status docker"
run_and_log "sudo systemctl status jenkins"
run_and_log "sudo docker ps"
run_and_log "trivy --version"

log "Script de configuração concluído"