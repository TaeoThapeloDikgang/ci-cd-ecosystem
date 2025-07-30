#!/bin/bash

ENV_FILE=".env"
DEPLOYMENT_FILE="k8s/ci-cd-ecosystem-deployment.yaml"
IMAGE_NAME="taeothapelodikgang/ci-cd-ecosystem-java-app"

echo "🐳 Watching $ENV_FILE for APP_TAG changes..."

last_tag=""

while true; do
  # Extract APP_TAG from .env
  current_tag=$(grep '^APP_TAG=' "$ENV_FILE" | cut -d '=' -f2)

  # Skip if APP_TAG is not found
  if [[ -z "$current_tag" ]]; then
    echo "⚠️ APP_TAG not found in $ENV_FILE"
    sleep 2
    continue
  fi

  if [[ "$current_tag" != "$last_tag" ]]; then
    echo "🔁 Detected new tag: $current_tag"

    # Use sed to replace the image tag in the YAML
    sed -i '' -E "s|($IMAGE_NAME:).*|\1$current_tag|g" "$DEPLOYMENT_FILE"

    echo "✅ Updated app tag in $DEPLOYMENT_FILE to $IMAGE_NAME:$current_tag"
    last_tag="$current_tag"

    # Optional: auto commit to Git
    # git add "$DEPLOYMENT_FILE"
    # git commit -m "Update image tag to $current_tag"
    # git push origin main
  fi

  sleep 2
done
