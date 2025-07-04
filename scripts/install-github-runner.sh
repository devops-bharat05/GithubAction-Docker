#!/bin/bash

# Update and install dependencies
sudo apt update -y && sudo apt upgrade -y
sudo apt install -y curl tar git

# Create a runner user
sudo useradd -m -s /bin/bash github-runner
cd /home/github-runner

# Download latest runner
RUNNER_VERSION="2.311.0"
ARCHIVE_NAME="actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz"
curl -o $ARCHIVE_NAME -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/$ARCHIVE_NAME
tar xzf $ARCHIVE_NAME

# Set permissions
sudo chown -R github-runner:github-runner /home/github-runner
chmod -R 755 /home/github-runner

# Generate GitHub registration token (manual step)
# Visit: https://github.com/<your-org>/<your-repo>/settings/actions/runners/new

# Configure the runner (manual token step below)
echo "Now run the below command after replacing the token:"
echo "./config.sh --url https://github.com/<your-username>/<your-repo> --token <TOKEN_HERE>"

# Optionally install as a service
echo "After configuration, run the following:"
echo "./svc.sh install"
echo "./svc.sh start"
