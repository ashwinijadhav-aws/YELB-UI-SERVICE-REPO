#!/bin/bash
#The -e option means that if any command exits with nonzero status, 
#bash will immediately exit itself, also with that status. It's a bit like exception handling for shell script.
set -e
SDLC_ENV=$1
REPO_NAME=$2
IMAGE_ID=$3
VERSION=$4

# check if image_id is provided or not

if [ $REPO_NAME == "" ]
then
   echo "please enter repository name where we want to push the images"
   exit 1
fi

# get the aws account id  associated with current IAM credentials 
#to declare the variable there should not be space between variable and = and expression account=$(expression)
#since we are runing a command the brackets are () and {} this means substitution
account=$(aws sts get-caller-identity --query Account --output text)

if [ $? -ne 0 ]
then 
    exit 255
fi

# form the repository name 
dockerhub_repo_name=$REPO_NAME
image_name=$SDLC_ENV-$IMAGE_ID-$VERSION

# get the  authentication done to the dockerhub repository repository for docker client

docker login --username ashwinijadhavaws --password Ash1w@na@aws

#build the image with Dockerfile present in the same directory as script hence . which represents dockerfile in current directory
# docker build -t $image_name -f Dockerfile
docker build -t $image_name .

tagforrepo="ashwinijadhavaws/${dockerhub_repo_name}:${image_name}"
echo "tagforrepo is $tagforrepo"

# tag the image with repo details where we need to push the image

docker tag $image_name $tagforrepo

# after tagging the image push the iamge

docker push $tagforrepo

# if the above command is successful 

if [ $? -eq 0 ]
then
    echo "Docker Push Event is successfull with $tagforrepo"
else
    echo "Docker Push Event failed."
fi

