# Smithery Deployment Guide

## Overview
Smithery enables secure, serverless hosting for stdio-based MCP servers with WebSocket support and a built-in playground for testing.

## Required Files
- `Dockerfile`: Multi-stage build for Linux, compiles Dart MCP server to a native binary (`server`).
- `smithery.yaml`: Specifies stdio start command and environment variable schema.

## Deployment Steps
1. Add your server to Smithery (or claim an existing one).
2. Access the Deployments tab (authenticated owners only).
3. Connect your repository and configure environment variables.
4. Deploy and verify using the MCP playground or compatible client.

## Best Practices
- Ensure `initialize` and `/tools/list` endpoints are accessible without API keys.
- Use ephemeral storage or external databases for persistent data.
- Test Dockerfile builds locally before deployment.

See `memory-bank/smithery-deployment-doc.md` for more details and advanced configuration options.
