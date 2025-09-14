#!/usr/bin/env bash
# Example: Trigger this workflow
# Replace <your-knative-service-url> with the service URL from `oc get ksvc`

KSVC_URL=${KSVC_URL:-"http://<your-knative-service-url>"}

curl -v $KSVC_URL \
  -H "Ce-Id: demo-001" \
  -H "Ce-Specversion: 1.0" \
  -H "Ce-Type: <entry-event-type>" \
  -H "Ce-Source: demo" \
  -H "Content-Type: application/json" \
  -d '{
        "id": "123",
        "payload": "example"
      }'
