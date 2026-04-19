#!/bin/bash

set -e
set -x

REPO_URL="https://${PAT}@dev.azure.com/<AZURE-DEVOPS-ORG-NAME>/voting-app/_git/voting-app"

git clone "$REPO_URL" /tmp/temp_repo
cd /tmp/temp_repo

FILE="k8s-specifications/$1-deployment.yaml"

sed -i "s|image:.*|image: voteapp1.azurecr.io/$2:$3|g" "$FILE"

git config user.email "pipeline@local.com"
git config user.name "azure-pipeline"

git add .

if git diff --cached --quiet; then
  echo "No changes"
else
  git commit -m "Update Kubernetes manifest"
  git push
fi

rm -rf /tmp/temp_repo