#!/bin/bash

set -e  # Exit script if any command fails

echo "🚀 Starting deployment on AWS server..."

# Navigate to the project directory
cd ~/fastapi-book-project || { echo "❌ Directory not found!"; exit 1; }

echo "📌 Stopping system-wide Nginx to avoid conflicts..."
sudo systemctl stop nginx || true
sudo systemctl disable nginx || true

echo "📌 Pulling the latest code from GitHub..."
git reset --hard origin/main
git pull origin main

echo "📌 Stopping and removing old Docker containers..."
docker-compose down || true

echo "📌 Removing unused Docker images and freeing up space..."
docker system prune -af || true

echo "📌 Rebuilding and restarting Docker containers..."
docker-compose up -d --build

echo "📌 Restarting Nginx inside Docker..."
docker exec nginx nginx -s reload || true

echo "🔍 Checking running Docker containers..."
docker ps

echo "🔍 Testing internal FastAPI endpoint..."
docker exec fastapi_app curl -X GET "http://127.0.0.1:8000/api/v1/books/1" || echo "❌ Internal API test failed!"

echo "🔍 Testing public API endpoint..."
curl -X GET "http://13.60.198.237/api/v1/books/1" || echo "❌ Public API test failed!"

echo "✅ Deployment completed successfully!"
