#!/usr/bin/env bash
# Trigger the baggage handling workflow

KSVC_URL=${KSVC_URL:-"http://<your-knative-service-url>"}

curl -v $KSVC_URL \
  -H "Ce-Id: bag-001" \
  -H "Ce-Specversion: 1.0" \
  -H "Ce-Type: checkInBaggage" \
  -H "Ce-Source: demo" \
  -H "Content-Type: application/json" \
  -d '{
        "bagId": "BAG123",
        "passengerId": "PAX42",
        "destination": "JFK"
      }'