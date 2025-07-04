#!/bin/bash

# Define the log file
LOG_FILE="installation_log.txt"

# Start logging
exec > >(tee -a "$LOG_FILE") 2>&1

echo ""
echo "############### Updating ###############"
sudo apt-get update
sudo apt install unzip -y

echo ""
echo "############### Installing Tree util ###############"
sudo apt install tree -y

echo ""
echo "############### Installing Docker ###############"
sudo apt install docker.io -y
#sudo systemctl status jenkins | grep -C 2 "active"

echo ""
echo "############### Add jenkins user to Docker group ###############"
#sudo usermod -a -G docker jenkins
echo ""
echo "############### Add Current i.e ubuntu user to the docker group ###############"
sudo usermod -aG docker $USER
echo ""
echo "############### Restart Jenkins service ###############"
#sudo service jenkins restart
echo ""
echo "############### Reload system daemon files ###############"
sudo systemctl daemon-reload
echo ""
echo "############### Change the permissions of the Docker socket ###############"
sudo chmod 666 /var/run/docker.sock
sudo systemctl restart docker

echo ""
echo "############### Installing Docker buildx ###############"
sudo apt install docker-buildx -y

# AWS CLI Installation
echo ""
echo "############### Installing AWS CLI ###############"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip aws/

# Helm Installation
echo ""
echo "############### Installing Helm ###############"
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
rm -f get_helm.sh

# eksctl Installation
echo ""
echo "############### Installing eksctl ###############"
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" | grep $PLATFORM | sha256sum --check
tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
sudo mv /tmp/eksctl /usr/local/bin

# kubectl Installation
echo ""
echo "############### Installing kubectl ###############"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
chmod +x kubectl
mkdir -p ~/.local/bin
mv ./kubectl ~/.local/bin/kubectl
rm -f kubectl kubectl.sha256

# Terraform Installation
echo ""
echo "############### Installing Terraform ###############"
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common

echo " Installing  the HashiCorp GPG key......"
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

echo " Verify the key's fingerprint....."
gpg --no-default-keyring  --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt-get install terraform -y

# Validate Installations
echo ""
echo "############### Validating installations ###############"
echo "AWS CLI Version: $(aws --version)"
echo "Helm Version: $(helm version --short)"
echo "eksctl Version:  $(eksctl version)"
echo "kubectl Version: $(kubectl version --client)"
echo "Terraform Version: $(terraform --version | head -n 1)"
echo "Installation of all tools completed successfully!"