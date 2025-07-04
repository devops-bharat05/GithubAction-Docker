#!/bin/bash

set -e # Exit immediately if a command exits with a non-zero status

echo "--- Checking for Docker installation ---"

# Function to install Docker (for Debian/Ubuntu based systems)
install_docker() {
    echo "Docker not found. Proceeding with Docker installation..."

    # Update package list
    sudo apt-get update -y

    # Install necessary packages for HTTPS transport
    sudo apt-get install -y ca-certificates curl gnupg lsb-release

    # Add Docker's official GPG key
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg # Ensure permissions are correct

    # Add Docker repository to APT sources
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Install Docker Engine
    sudo apt-get update -y
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo usermod -aG docker $USER

    # Start and enable Docker service
    echo "Starting and enabling Docker service..."
    sudo systemctl start docker
    sudo systemctl enable docker

    # Optional: Add the current user to the 'docker' group.
    # This allows running docker commands without 'sudo'.
    # Note: For this to take effect in the *current* shell session of the CI/CD job,
    # it often requires re-logging in or starting a new shell.
    # In a CI/CD context, if the runner user is not already in the docker group,
    # you might still need to use 'sudo docker ...' for subsequent commands in the same job,
    # or consider pre-configuring the runner user.
    # If the runner user is 'gitlab-runner' or similar:
    # sudo usermod -aG docker $(whoami) || true
    # echo "Added $(whoami) to 'docker' group. You may need to restart your session or runner for changes to apply."

    echo "Docker installation complete."
}

# Check if Docker command exists
if command -v docker &> /dev/null; then
    echo "Docker command found."
    # Check if Docker daemon is running
    if systemctl is-active --quiet docker; then
        echo "Docker daemon is running."
    else
        echo "Docker daemon is not running. Attempting to start it..."
        sudo systemctl start docker || true # Use || true to prevent script failure if already started or permission issues
        sudo systemctl enable docker || true
        if systemctl is-active --quiet docker; then
            echo "Docker daemon started successfully."
        else
            echo "Failed to start Docker daemon. Please check logs."
            exit 1
        fi
    fi
else
    install_docker
fi

echo "--- Docker check/installation complete ---"
echo "Docker version:"
docker --version
echo "Docker info:"
docker info