# Docker Command Guide

## Introduction
This document provides a comprehensive guide to commonly used Docker commands for managing images, containers, and Docker Hub interactions efficiently.

[My docker-hub example](https://hub.docker.com/repository/docker/benson1231/test/general)

## Docker Version
Check the installed Docker version:
```bash
docker version
```

## Building Docker Images
Create a Docker image from a Dockerfile:
```bash
docker build -t <image_name> .
```

## Listing Docker Images
View all available images:
```bash
docker images
```

## Managing Containers
### Listing Running and All Containers
```bash
# List only running containers
docker ps

# List all containers (including stopped ones)
docker ps -a
```

### Running Containers
```bash
# Run an image in a container
docker run <image_name>

# Run an image in the background (detached mode)
docker run -d <image_name>
```

### Starting and Stopping Containers
```bash
# Start a stopped container
docker start <container_ID>

# Stop a running container
docker stop <container_ID>
```

### Removing Containers
```bash
# Remove a stopped container
docker rm <container_ID>
```

## Managing Docker Images
### Removing Images
```bash
# Remove an image
docker rmi <image_name>
```

### Tagging Images
```bash
# Add a tag to an image
docker tag <local_image:tagname> <docker_hub_name/repo:tagname>
```

### Pushing and Pulling Images
```bash
# Push an image to Docker Hub
docker push <docker_hub_name/repo:tagname>

# Pull an image from Docker Hub
docker pull <docker_hub_name/repo:tagname>
```

## Cleaning Up Unused Resources
### Removing Unused Docker Resources
```bash
# Remove unused containers, networks, and images
docker system prune

# Remove all unused images, not just dangling ones
docker system prune -a
```

## Viewing Logs
```bash
# View logs of a running container
docker logs <container_ID>

# Follow live logs
docker logs -f <container_ID>
```

## Executing Commands in Running Containers
```bash
# Open an interactive Bash session inside a running container
docker exec -it <container_ID> bash
```

## Using Docker Compose
```bash
# Start all services defined in docker-compose.yml
docker-compose up

# Stop all services defined in docker-compose.yml
docker-compose down
```

## Conclusion
This guide serves as a quick reference for essential Docker commands to streamline container management and image handling. Ensure to adapt these commands based on specific project requirements.

