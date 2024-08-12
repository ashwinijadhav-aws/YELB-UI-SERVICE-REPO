#!/bin/bash
# build_image.sh

# Check for necessary arguments
if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <image-name> <sdlc-environment>"
  exit 1
fi

SDLC_ENVIRONMENT=$2
ECR_REPO_NAME=$1

echo "Building Docker image: $ECR_REPO_NAME"

# Get the source directory
src_dir=$CODEBUILD_SRC_DIR

# Build the Docker image locally
docker build -t ${ECR_REPO_NAME} $src_dir/YELB-APP/yelb-ui/
if [ $? -ne 0 ]; then
  echo "Docker build failed"
  exit 1
fi

echo "Image built successfully: ${ECR_REPO_NAME}"

