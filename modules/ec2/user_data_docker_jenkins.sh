#!/bin/bash
set -e

# Função para registro de log
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Função para verificar a instalação
check_installation() {
    if ! command -v $1 &> /dev/null; then
        log "Erro: $1 não foi instalado corretamente."
        exit 1
    else
        log "$1 instalado com sucesso."
    fi
}

# Função para iniciar e verificar container
start_and_check_container() {
    container_name=$1
    log "Iniciando container $container_name..."
    docker start $container_name || docker run -d --name $container_name $2
    sleep 10  # Espera 10 segundos para o container inicializar
    if [ "$(docker ps -q -f name=$container_name)" ]; then
        log "Container $container_name está rodando."
    else
        log "Erro: Container $container_name não está rodando."
        exit 1
    fi
}

# Atualizar pacotes
log "Atualizando pacotes..."
sudo apt-get update && sudo apt-get upgrade -y

# Verificar se o repositório já foi clonado
if [ ! -d "DevSecOps-Project" ]; then
    log "Clonando o repositório..."
    git clone https://github.com/N4si/DevSecOps-Project.git
    if [ $? -ne 0 ]; then
        log "Erro ao clonar o repositório. Verifique a conexão com a internet e as permissões."
        exit 1
    fi
fi
cd DevSecOps-Project

# Instalar Docker
log "Instalando Docker..."
sudo apt-get install docker.io -y
sudo usermod -aG docker $USER
newgrp docker
sudo chmod 777 /var/run/docker.sock
check_installation docker

# Construir a aplicação Netflix
log "Construindo a aplicação Netflix... (Isso pode demorar alguns minutos)"
docker build --build-arg TMDB_V3_API_KEY=69f97abb81b78cb1ed303b9ff3187fec -t netflix .

# Iniciar e verificar o container Netflix
start_and_check_container "netflix" "netflix:latest -p 8081:80"

# Iniciar e verificar o container SonarQube
start_and_check_container "sonarqube" "sonarqube:lts-community -p 9000:9000 -p 9092:9092"

# Instalar Trivy
log "Instalando Trivy..."
sudo apt-get install wget apt-transport-https gnupg lsb-release -y
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy -y
check_installation trivy

# Instalar Java
log "Instalando Java..."
sudo apt install fontconfig openjdk-17-jre -y
check_installation java

# Instalar Jenkins
log "Instalando Jenkins..."
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins -y
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Imprimir a senha inicial do Jenkins
log "Senha inicial do Jenkins:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

log "Script de configuração concluído com sucesso"