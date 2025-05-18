#!/bin/bash 

# Define color codes
INFO='\033[0;36m'   # Cyan
BANNER='\033[1;35m' # Bright Magenta
YELLOW='\033[1;33m' # Bright Yellow
RED='\033[1;31m'    # Bright Red
GREEN='\033[1;32m'  # Bright Green
BLUE='\033[1;34m'   # Bright Blue
CYAN='\033[1;36m'   # Bright Cyan
NC='\033[0m'        # No Color

# Display banner
echo -e "${BANNER}"
echo "====================================================="
echo "             DRIA NODE RUN BY MeG                   "
echo "====================================================="
echo -e "${NC}"

echo -e "${CYAN}Follow on X:${NC} ${GREEN}https://x.com/Jaishiva0302${NC}"
echo -e "${CYAN}Join Telegram for more alpha:${NC} ${GREEN}https://t.me/vampsairdrop${NC}"
echo -e ""

# Update package lists and upgrade installed packages
echo -e "${YELLOW}Updating and upgrading system packages...${NC}"
sudo apt update -y && sudo apt upgrade -y

# Check if Docker is already installed
if command -v docker &> /dev/null; then
    echo -e "${GREEN}Docker is already installed, skipping Docker installation.${NC}"
else
    echo -e "${YELLOW}Installing required dependencies for Docker...${NC}"
    sudo apt install -y \
      apt-transport-https \
      ca-certificates \
      curl \
      software-properties-common \
      lsb-release \
      gnupg2

    echo -e "${YELLOW}Adding Docker's official GPG key...${NC}"
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    echo -e "${YELLOW}Adding Docker repository...${NC}"
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    echo -e "${YELLOW}Updating package lists...${NC}"
    sudo apt update -y

    echo -e "${YELLOW}Installing Docker...${NC}"
    sudo apt install -y docker-ce docker-ce-cli containerd.io

    if ! command -v docker &> /dev/null; then
        echo -e "${RED}Docker installation failed!${NC}"
        exit 1
    else
        echo -e "${GREEN}Docker is successfully installed!${NC}"
    fi
fi

# Check if Docker Compose is already installed
if command -v docker-compose &> /dev/null; then
    echo -e "${GREEN}Docker Compose is already installed, skipping Docker Compose installation.${NC}"
else
    echo -e "${YELLOW}Installing Docker Compose...${NC}"
    VER=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4)
    curl -L "https://github.com/docker/compose/releases/download/$VER/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    echo -e "${GREEN}Docker Compose has been installed!${NC}"
fi

# Add current user to Docker group
if ! groups $USER | grep -q '\bdocker\b'; then
    echo -e "${YELLOW}Adding user to Docker group...${NC}"
    sudo groupadd docker
    sudo usermod -aG docker $USER
else
    echo -e "${GREEN}User is already in the Docker group.${NC}"
fi

# Install Screen if not installed
if command -v screen &> /dev/null; then
    echo -e "${GREEN}Screen is already installed, skipping installation.${NC}"
else
    echo -e "${YELLOW}Installing Screen...${NC}"
    sudo apt install -y screen
fi

# Install Unzip
echo -e "${YELLOW}Installing Unzip...${NC}"
sudo apt install -y unzip

# Install Ollama
echo -e "${YELLOW}Installing Ollama...${NC}"
curl -fsSL https://ollama.com/install.sh | sh

# Check Ollama version
echo -e "${YELLOW}Ollama version:${NC}"
ollama --version

# Start Ollama service
echo -e "${YELLOW}Starting Ollama service...${NC}"
ollama start &

# Pull Ollama models
echo -e "${YELLOW}Pulling Ollama models...${NC}"
ollama pull hellord/mxbai-embed-large-v1:f16
ollama pull llama3.1:latest
ollama pull llama3.2:1b

# Install DKN Compute Node
echo -e "${YELLOW}Installing DKN Compute Node...${NC}"
cd "$HOME"
curl -fsSL https://dria.co/launcher | bash

# Add dria binary to PATH for current session
echo -e "${YELLOW}Adding Dria Compute Launcher to PATH for this session...${NC}"
export PATH="$PATH:/root/.dria/bin"

# Start the Dria node
echo -e "${YELLOW}Starting Dria Compute Node...${NC}"
dkn-compute-launcher start


echo -e "${GREEN}Installation completed.${NC}"

echo -e "${BANNER}==================================="
echo -e "     DRIA NODE SETUP COMPLETE     "
echo -e "             by MeG               "
echo -e "===================================${NC}"
