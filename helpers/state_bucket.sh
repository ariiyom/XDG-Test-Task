#!/bin/bash

if ! command -v gcloud &> /dev/null
then
    echo "gcloud sdk not found. Please install it"
    exit 1
fi

if [ "$#" -ne 3 ]; 
then
    echo "Incorrect number of arguments"
    echo "Expects: $0 <bucket-name> <location> <project-id>"
    exit 1
fi

BUCKET_NAME=$1
LOCATION=$2
PROJECT_ID=$3

gcloud storage buckets create gs://$BUCKET_NAME --location=$LOCATION --project=$PROJECT_ID

if [ $? -eq 0 ];
then
    echo "Bucket $BUCKET_NAME was created successfully in project $PROJECT_ID"
else
    echo "Failed to create bucket $BUCKET_NAME in project $PROJECT_ID"
    exit 1
fi
