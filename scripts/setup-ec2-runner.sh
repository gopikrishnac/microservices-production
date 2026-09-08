#!/usr/bin/env bash

set -euo pipefail

# Configuration variables (Pass via CLI or replace below)
REPO_URL="${1:-}"
RUNNER_TOKEN="${2:-}"
RUNNER_VERSION="2.320.0"

if [[ -z "$REPO_URL" || -z "$RUNNER_TOKEN" ]]; then
  echo "Usage: $0 <GITHUB_REPO_URL> <RUNNER_REGISTRATION_TOKEN>"
  echo "Example: $0 https://github.com/myuser/microservices-production ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  exit 1
fi

echo "===> 1. Updating system and installing base dependencies..."
sudo apt update -y && sudo apt upgrade -y
sudo apt install -y curl git jq build-essential libssl-dev libffi-dev python3-pip

echo "===> 2. Installing Docker Engine..."
sudo apt install -y docker.io
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"

echo "===> 3. Installing Trivy (Vulnerability Scanner)..."
sudo apt install -y wget apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt update -y
sudo apt install -y trivy

echo "===> 4. Downloading and Configuring GitHub Actions Runner..."
mkdir -p "$HOME/actions-runner" && cd "$HOME/actions-runner"

curl -o actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -L \
  "https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz"

tar xzf "./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz"

# Configure runner non-interactively
./config.sh --url "$REPO_URL" --token "$RUNNER_TOKEN" --labels "cicd-runner" --unattended --replace

echo "===> 5. Installing runner as a systemd service..."
sudo ./svc.sh install
sudo ./svc.sh start

echo "Runner setup complete and running!"