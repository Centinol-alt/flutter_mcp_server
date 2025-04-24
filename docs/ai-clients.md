# AI Client Integration Guide

## Overview
This guide describes how to connect AI assistants (e.g., Claude, Cursor, Windsurf) to the Flutter MCP Server.

## Supported Clients
- Claude Desktop
- Cursor
- Windsurf
- Cline

## Integration Steps
1. Ensure the MCP server is deployed and accessible via Smithery or local endpoint.
2. In the AI client, add the MCP server endpoint (Smithery provides the WebSocket URL).
3. Use the MCP client's UI to discover tools and resources exposed by the server.
4. Test tool invocations (e.g., analyze, format, run) and resource queries.

## Example
- In Windsurf, add the MCP server using its Smithery registry URL or direct WebSocket endpoint.
- Use the built-in playground to test tool and resource interactions.

## Troubleshooting
- Ensure environment variables and secrets are set correctly in the deployment interface.
- Check Smithery deployment logs for errors.
- Refer to the main README and docs for specific tool usage.
