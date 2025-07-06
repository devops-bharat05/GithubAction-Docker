#!/bin/bash

# Define variables
RUNNER_VERSION="2.325.0"
RUNNER_OS="linux"
RUNNER_ARCHITECTURE="x64"
RUNNER_PACKAGE="actions-runner-${RUNNER_OS}-${RUNNER_ARCHITECTURE}-${RUNNER_VERSION}.tar.gz"
RUNNER_DOWNLOAD_URL="https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/${RUNNER_PACKAGE}"
RUNNER_DIR="actions-runner"

# Ensure the runner directory exists and navigate into it
mkdir -p "$RUNNER_DIR" && cd "$RUNNER_DIR"

# Download the runner package
curl -o "$RUNNER_PACKAGE" -L "$RUNNER_DOWNLOAD_URL"

# Extract the installer
tar xzf ./"$RUNNER_PACKAGE"

# Create the runner and start the configuration experience
# Note: The token is passed as an environment variable in the GitHub Actions workflow for security.
./config.sh --url "$REPO_URL" --token "$RUNNER_TOKEN" --labels "$RUNNER_LABELS" --name "$RUNNER_NAME"

# Start the runner as a service (optional, depends on your needs)
# sudo ./svc.sh install
# sudo ./svc.sh start

# Or, run the runner directly (for testing or non-service use cases)
./run.sh
