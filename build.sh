#!/bin/bash

# Build script for optimized Docker builds
# Handles app updates efficiently

set -e

IMAGE_NAME=${1:-"frappe-app"}
FORCE_REBUILD=${2:-"false"}

echo "🐳 Building Docker image: $IMAGE_NAME"

# Check if apps have been updated
echo "🔍 Checking for app updates..."
if [ -f "scripts/check-app-updates.sh" ]; then
    if ./scripts/check-app-updates.sh; then
        echo "✅ No app updates detected"
        if [ "$FORCE_REBUILD" = "true" ]; then
            echo "🔄 Force rebuild requested"
            APP_UPDATE_TIMESTAMP=$(date +%s)
        else
            echo "💡 Using cached app layer (add 'force' as second argument to force rebuild)"
            APP_UPDATE_TIMESTAMP=1
        fi
    else
        echo "🔄 App updates detected, forcing rebuild"
        APP_UPDATE_TIMESTAMP=$(date +%s)
    fi
else
    echo "⚠️  Update check script not found, using timestamp"
    APP_UPDATE_TIMESTAMP=$(date +%s)
fi

# Build the Docker image
echo "🏗️  Building with APP_UPDATE_TIMESTAMP=$APP_UPDATE_TIMESTAMP"
docker build \
    --build-arg APP_UPDATE_TIMESTAMP="$APP_UPDATE_TIMESTAMP" \
    -t "$IMAGE_NAME" \
    .

echo "✅ Build complete!"
echo ""
echo "Usage examples:"
echo "  ./build.sh                    # Build with smart caching"
echo "  ./build.sh my-image           # Build with custom image name"
echo "  ./build.sh my-image force     # Force rebuild even if no updates"
