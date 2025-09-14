#!/usr/bin/env bash
set -e

BASE_DIR=$(pwd)

WORKFLOWS=(
  baggage-handler
  employee-onboarding
  package-delivery
  ride-matching
  supermarket-layaway
  insurance-claim
  mortgage-application
)

echo "📄 Generating README.md and curl-examples.sh for workflows..."

for wf in "${WORKFLOWS[@]}"; do
  DIR="$BASE_DIR/$wf"
  DIAGRAM_FILE="$DIR/diagram.txt"

  if [[ ! -d "$DIR" ]]; then
    echo "⚠️  Skipping $wf (folder not found)"
    continue
  fi

  # 1. README.md
  README="$DIR/README.md"
  cat > "$README" <<EOF
# ${wf//-/ } Workflow

This workflow demonstrates a real-world event-driven process modeled with **Quarkus Funqy Knative Events**.

## Diagram
\`\`\`
$(cat "$DIAGRAM_FILE")
\`\`\`

## Event Flow
- Starts with a CloudEvent of type specific to this workflow (see curl example below).
- Events flow step by step, emitting new CloudEvents at each stage.
- Some transitions use **configChain mappings** (defined in \`application.properties\`).
- Others use **@CloudEventMapping annotations** to route based on ce-type.

## Expected Output
Each step enriches the object with new status information until the final step completes the workflow.
EOF

  # 2. curl-examples.sh
  CURL="$DIR/curl-examples.sh"
  cat > "$CURL" <<'EOF'
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
EOF
  chmod +x "$CURL"

  echo "✅  Created $README and $CURL"
done

echo "🎉  All docs generated successfully."