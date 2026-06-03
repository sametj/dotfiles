#!/usr/bin/env python3
"""
luau-bridge.py — Bridges the Luau LSP Companion Studio plugin to luau-lsp in Neovim.

The Studio plugin sends HTTP requests to this server.
This script forwards them as LSP notifications to luau-lsp via Neovim's RPC socket.

Usage:
  python3 luau-bridge.py [--port 21121] [--nvim-socket /tmp/nvim.sock]

Requirements:
  pip install flask pynvim --break-system-packages
"""

import argparse
import gzip
import json
import threading
import sys

try:
    from flask import Flask, request, jsonify
except ImportError:
    print("Missing dependency: pip install flask --break-system-packages")
    sys.exit(1)

try:
    import pynvim
except ImportError:
    print("Missing dependency: pip install pynvim --break-system-packages")
    sys.exit(1)

app = Flask(__name__)
nvim_socket = None
nvim = None
nvim_lock = threading.Lock()


def get_nvim():
    global nvim
    try:
        if nvim is None:
            nvim = pynvim.attach("socket", path=nvim_socket)
        # Test the connection is still alive
        nvim.eval("1")
    except Exception:
        nvim = None
        try:
            nvim = pynvim.attach("socket", path=nvim_socket)
        except Exception as e:
            print(f"[bridge] Failed to connect to Neovim socket: {e}")
            return None
    return nvim


def send_lsp_notification(method, params):
    n = get_nvim()
    if not n:
        return False
    try:
        with nvim_lock:
            # Get just the luau-lsp client ID (avoids converting complex Lua objects)
            client_id = n.exec_lua("""
                for _, c in ipairs(vim.lsp.get_clients()) do
                    if c.name == "luau-lsp" then return c.id end
                end
                return nil
            """)

            if client_id:
                import tempfile, os
                with tempfile.NamedTemporaryFile(mode="w", suffix=".json", delete=False) as f:
                    json.dump(params, f)
                    tmp_path = f.name
                lua = f"""
local f = io.open("{tmp_path}", "r")
local data = f:read("*a")
f:close()
os.remove("{tmp_path}")
local c = vim.lsp.get_client_by_id({client_id})
if c then c.notify("{method}", vim.fn.json_decode(data)) end
"""
                n.exec_lua(lua)
                print(f"[bridge] Sent {method} to luau-lsp (client {client_id})")
                return True

            print("[bridge] luau-lsp client not found in Neovim")
            return False
    except Exception as e:
        print(f"[bridge] Error sending LSP notification: {e}")
        return False


@app.route("/get-file-paths", methods=["GET"])
def get_file_paths():
    """Studio plugin asks for file paths — return empty list (Rojo handles this)."""
    return jsonify([])


@app.route("/full", methods=["POST"])
def full():
    """Studio sends the full DataModel tree."""
    raw = request.data

    # Decompress if gzip-encoded
    if raw[:2] == b"\x1f\x8b":
        try:
            raw = gzip.decompress(raw)
        except Exception as e:
            return f"Failed to decompress body: {e}", 400

    try:
        body = json.loads(raw)
    except Exception as e:
        return f"Failed to parse JSON: {e}", 400

    print(f"[bridge] /full parsed body keys: {list(body.keys()) if body else None}")

    if not body or "tree" not in body:
        # Maybe the body IS the tree directly
        if body and "Name" in body and "ClassName" in body:
            tree = body
        else:
            return f"Bad Request: missing 'tree', got keys: {list(body.keys()) if body else 'none'}", 400
    else:
        tree = body["tree"]

    print(f"[bridge] Received full DataModel tree: {tree.get('Name', '?')}")
    ok = send_lsp_notification("$/plugin/full", tree)
    return ("OK", 200) if ok else ("LSP not ready", 500)


@app.route("/clear", methods=["POST"])
def clear():
    """Studio signals to clear the DataModel tree."""
    print("[bridge] Received clear request")
    send_lsp_notification("$/plugin/clear", {})
    return "OK", 200


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Luau LSP Studio bridge for Neovim")
    parser.add_argument("--port", type=int, default=21121, help="HTTP port (default: 21121)")
    parser.add_argument("--nvim-socket", default="/tmp/nvim.sock", help="Neovim RPC socket path")
    args = parser.parse_args()

    nvim_socket = args.nvim_socket

    print(f"[bridge] Starting on port {args.port}")
    print(f"[bridge] Connecting to Neovim socket: {nvim_socket}")
    print(f"[bridge] Make sure Neovim is running with: NVIM_LISTEN_ADDRESS={nvim_socket} nvim")

    app.run(host="0.0.0.0", port=args.port, debug=False)
