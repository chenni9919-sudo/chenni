#!/usr/bin/env bash
set -euo pipefail

# Install Kling MCP (Cursor) + official Kling CLI on your local machine.
# Usage:
#   bash scripts/setup-kling-local.sh          # global site (default)
#   bash scripts/setup-kling-local.sh cn       # China site

REGION="${1:-global}"
MCP_CONFIG_DIR="${HOME}/.cursor"
MCP_CONFIG_FILE="${MCP_CONFIG_DIR}/mcp.json"
KLING_MCP_URL="https://klingai.com/mcp"

if [[ "${REGION}" == "cn" ]]; then
  CLI_PACKAGE="@klingai/cli-cn"
  SITE_LABEL="国内站 (klingai.com)"
else
  CLI_PACKAGE="@klingai/cli-global"
  SITE_LABEL="海外站 (global)"
fi

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Error: '$1' is required but not found." >&2
    exit 1
  fi
}

require_command node
require_command npm

NODE_MAJOR="$(node -p "process.versions.node.split('.')[0]")"
if [[ "${NODE_MAJOR}" -lt 18 ]]; then
  echo "Error: Node.js 18+ is required (found $(node -v))." >&2
  exit 1
fi

echo "==> Installing Kling CLI (${SITE_LABEL})"
npm install -g "${CLI_PACKAGE}@latest" --registry=https://registry.npmjs.org

echo "==> Writing Cursor MCP config: ${MCP_CONFIG_FILE}"
mkdir -p "${MCP_CONFIG_DIR}"

python3 - <<'PY' "${MCP_CONFIG_FILE}" "${KLING_MCP_URL}"
import json
import sys
from pathlib import Path

config_path = Path(sys.argv[1])
mcp_url = sys.argv[2]

if config_path.exists():
    data = json.loads(config_path.read_text(encoding="utf-8"))
else:
    data = {}

servers = data.setdefault("mcpServers", {})
servers["kling"] = {"url": mcp_url}

config_path.write_text(
    json.dumps(data, indent=2, ensure_ascii=False) + "\n",
    encoding="utf-8",
)
PY

echo
echo "==> Setup complete"
echo
echo "Next steps:"
echo "  1. Restart Cursor (or reload window)."
echo "  2. Open Cursor Settings -> MCP, find 'kling', click Connect, and authorize in browser."
echo "  3. Run 'kling login' in terminal to authorize the CLI (separate OAuth session)."
echo "  4. Verify with: kling who_am_i"
echo
echo "One-click MCP install deeplink:"
python3 - <<'PY'
import base64, json
config = {"url": "https://klingai.com/mcp"}
encoded = base64.b64encode(json.dumps(config, separators=(",", ":")).encode()).decode()
print(f"cursor://anysphere.cursor-deeplink/mcp/install?name=kling&config={encoded}")
PY

read -r -p "Run 'kling login' now to authorize CLI? [y/N] " answer || true
if [[ "${answer:-}" =~ ^[Yy]$ ]]; then
  kling login
  echo
  echo "CLI login finished. Try: kling who_am_i"
fi
