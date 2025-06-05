#!/bin/bash

set -e

echo "🔧 Installing Grafana OSS on Amazon Linux 2023..."

# Step 1: Add Grafana GPG key and repository
sudo tee /etc/yum.repos.d/grafana.repo > /dev/null <<EOF
[grafana]
name=Grafana OSS Repository
baseurl=https://rpm.grafana.com/oss/rpm
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://rpm.grafana.com/gpg.key
EOF

# Step 2: Install Grafana
sudo dnf clean all
sudo dnf makecache
sudo dnf install grafana -y

# Step 3: Enable and start Grafana service
sudo systemctl enable --now grafana-server

# Step 4: Open port 3000 in firewalld (optional if security group is already open)
# sudo firewall-cmd --add-port=3000/tcp --permanent
# sudo firewall-cmd --reload

echo "✅ Grafana installed and running at http://<your-ec2-public-ip>:3000"
echo "📌 Default login: admin / admin (you will be prompted to change it after first login)"
