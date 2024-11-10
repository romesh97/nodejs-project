#!/bin/bash
# Update the package index
sudo apt-get update -y

# Install prerequisites
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set up the Docker stable repository
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt-get update -y
sudo apt-get install -y docker-ce
 
# Enable Docker to start on boot
sudo systemctl enable docker
sudo systemctl start docker

# Part 2 #######################################

# Install Git if not already installed
sudo apt-get update -y
sudo apt-get install -y git

# Clone the repository
git clone https://github.com/romesh97/simple-nodejs.git /home/romanet/app

# Navigate to the application directory
cd /home/romanet/app

# Build the Docker image
sudo docker build -t sample-app .

# Run the Docker container
sudo docker run -d -p 80:8080 sample-app

############### Part 3

# Variables
ACR_NAME="networkReg"  # Name of the Azure Container Registry
APP_NAME="sample-app"  # Name of the Docker image
IMAGE_TAG="v1"

# Log in to ACR
az acr login --name $ACR_NAME

# # Clone the repository
# git clone https://github.com/romesh97/simple-nodejs.git /home/romanet/app
# cd /home/romanet/app

# # Build the Docker image
# sudo docker build -t $APP_NAME .

# Tag the image for ACR
sudo docker tag $APP_NAME $ACR_NAME.azurecr.io/$APP_NAME:$IMAGE_TAG

# Push the image to ACR
sudo docker push $ACR_NAME.azurecr.io/$APP_NAME:$IMAGE_TAG

# Pull the Docker image from ACR's
sudo docker pull $ACR_NAME.azurecr.io/$APP_NAME:$IMAGE_TAG

# Run the Docker container
sudo docker run -d -p 8081:8080 $ACR_NAME.azurecr.io/$APP_NAME:$IMAGE_TAG

