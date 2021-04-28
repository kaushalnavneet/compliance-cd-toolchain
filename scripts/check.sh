#!/usr/bin/env bash

set -euo pipefail

defs=$(mktemp)

echo "Linting CD Pipeline"
yq r -j .bluemix/tekton.yaml | jq -r '.inputs[] | select(.service=="${TEKTON_DEFINITION_REPO}") | .path + "/*.yaml"' | tee -a "$defs"

tekton-lint $(cat "$defs")
