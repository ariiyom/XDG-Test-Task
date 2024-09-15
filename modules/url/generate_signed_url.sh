#!/bin/bash

GCS_OBJECT_FILE=$1
URL_PREFIX=$2
SECRET_NAME=$3
KEY_FILE=$4
EXPIRATION=$5

while IFS= read -r OBJECT; do
  # Remove any leading/trailing whitespace
  OBJECT=$(echo "$OBJECT" | xargs)
  
  # Skip empty lines
  if [[ -z "$OBJECT" ]]; then
    continue
  fi
  OBJECT="${OBJECT#*/*/*/}"

  URL="$URL_PREFIX/$OBJECT"

  # Generate the signed URL 
  gcloud compute sign-url $URL --key-name $SECRET_NAME --key-file $KEY_FILE --expires-in $EXPIRATION
 
done < $GCS_OBJECT_FILE