#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "===> 1. Starting containers via Docker Compose..."
docker compose up --build -d

echo "===> 2. Waiting for containers to become healthy..."
sleep 8

echo "===> 3. Testing endpoints..."
echo -n "Auth Service: "
curl -sf http://localhost:3000/healthz && echo " [OK]" || echo " [FAILED]"

echo -n "Product Service: "
curl -sf http://localhost:8000/healthz && echo " [OK]" || echo " [FAILED]"

echo -n "Order Service: "
curl -sf http://localhost:8080/healthz && echo " [OK]" || echo " [FAILED]"

echo "===> Done. View logs with: docker compose logs -f"