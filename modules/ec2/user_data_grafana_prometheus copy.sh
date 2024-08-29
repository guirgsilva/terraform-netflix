#!/bin/bash
set -e

# Função para log
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a /var/log/user_data.log
}

log "Iniciando script de configuração"

# Atualizar pacotes
log "Atualizando pacotes"
apt-get update
apt-get upgrade -y

# Instalar dependências necessárias
log "Instalando dependências"
apt-get install -y wget curl apt-transport-https software-properties-common

# Limpar qualquer instalação parcial anterior
log "Limpando instalações parciais anteriores"
rm -rf /etc/prometheus /data /usr/local/bin/prometheus /usr/local/bin/promtool

# Instalar Prometheus
log "Instalando Prometheus"
wget https://github.com/prometheus/prometheus/releases/download/v2.47.1/prometheus-2.47.1.linux-amd64.tar.gz
tar xvf prometheus-2.47.1.linux-amd64.tar.gz
cd prometheus-2.47.1.linux-amd64/
mkdir -p /data /etc/prometheus
mv prometheus promtool /usr/local/bin/
mv consoles/ console_libraries/ /etc/prometheus/
mv prometheus.yml /etc/prometheus/prometheus.yml
cd ..
rm -rf prometheus-2.47.1.linux-amd64*

# Configurar usuário e permissões do Prometheus
log "Configurando usuário e permissões do Prometheus"
useradd --system --no-create-home --shell /bin/false prometheus
chown -R prometheus:prometheus /etc/prometheus/ /data/
chown prometheus:prometheus /usr/local/bin/prometheus
chown prometheus:prometheus /usr/local/bin/promtool

# Criar arquivo de serviço do Prometheus
log "Criando arquivo de serviço do Prometheus"
cat > /etc/systemd/system/prometheus.service <<EOF
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/data \
  --web.console.templates=/etc/prometheus/consoles \
  --web.console.libraries=/etc/prometheus/console_libraries \
  --web.listen-address=0.0.0.0:9090 \
  --web.enable-lifecycle

[Install]
WantedBy=multi-user.target
EOF

# Iniciar e habilitar Prometheus
log "Iniciando e habilitando Prometheus"
systemctl daemon-reload
systemctl enable prometheus
systemctl start prometheus

# Verificar status do Prometheus
log "Verificando status do Prometheus"
systemctl status prometheus --no-pager

# Adicionar /usr/local/bin ao PATH
log "Adicionando /usr/local/bin ao PATH"
echo 'export PATH=$PATH:/usr/local/bin' >> /etc/profile

# Instalar Grafana
log "Instalando Grafana"
wget -q -O - https://packages.grafana.com/gpg.key | apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | tee -a /etc/apt/sources.list.d/grafana.list
apt-get update
apt-get install -y grafana

# Iniciar e habilitar Grafana
log "Iniciando e habilitando Grafana"
systemctl start grafana-server
systemctl enable grafana-server

# Verificar status do Grafana
log "Verificando status do Grafana"
systemctl status grafana-server --no-pager

log "Script de configuração concluído"