#!/bin/bash
#Bash script for installing node_exporter, downloads version 1.4.0, extracts it, creates a 
service user, and creates a systemd unit file

echo "Downloading Node Exporter v1.4.0"

wget 
https://github.com/prometheus/node_exporter/releases/download/v1.4.0-rc.0/node_exporter-1.4.0-rc.0.linux-amd64.tar.gz
echo "Extracting Node Exporter"
tar -xvf node_exporter-1.4.0-rc.0.linux-amd64.tar.gzz

echo "Moving Node Exporter binary"

cd node_exporter-1.4.0-rc.0.linux-amd64.tar.gz
sudo cp node_exporter /usr/local/bin/

echo "Adding node_exporter service account"
sudo useradd -rs /bin/false node_exporter

echo "Creating systemd unit file -- node_exporter.service"

sudo cat << EOF >> /etc/systemd/system/node_exporter.service

[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

echo "Reloading systemd"

sudo systemctl daemon-reload

echo "Enabling node_exporter service"
sudo systemctl enable node_exporter

echo "Restarting Node Exporter"
sudo systemctl restart node_exporter

echo "Displaying Node Exporter Status"
sudo systemctl status node_exporter
