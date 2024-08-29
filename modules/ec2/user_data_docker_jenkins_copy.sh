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

# Atualizar pacotes
log "Atualizando pacotes..."
sudo apt-get update && sudo apt-get upgrade -y

# Clonar o repositório
log "Clonando o repositório..."
if [ ! -d "DevSecOps-Project" ]; then
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

# Construir e executar a aplicação Netflix
log "Construindo a aplicação Netflix... (Isso pode demorar alguns minutos)"
docker build --build-arg TMDB_V3_API_KEY=69f97abb81b78cb1ed303b9ff3187fec -t netflix . &
build_pid=$!

# Instalar SonarQube
log "Instalando SonarQube..."
docker run -d --name sonar -p 9000:9000 sonarqube:lts-community
log "Aguardando SonarQube iniciar... (Isso pode levar alguns minutos)"
until $(curl --output /dev/null --silent --head --fail http://localhost:9000); do
    printf '.'
    sleep 5
done
log "SonarQube está rodando."

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

# Aguardar a construção do Netflix terminar
log "Aguardando a construção do Netflix terminar..."
wait $build_pid
if [ $? -ne 0 ]; then
    log "Erro na construção do container Netflix."
    exit 1
fi

# Executar o container Netflix
log "Executando o container Netflix..."
docker run -d --name netflix -p 8081:80 netflix:latest

log "Script de configuração concluído com sucesso"