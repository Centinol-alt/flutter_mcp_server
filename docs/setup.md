# Setup Guide for Flutter MCP Server

## Prerequisites
- Dart SDK (≥3.4.4)
- Flutter SDK
- Docker (for container builds and Smithery deployment)
- Smithery account (for cloud deployment)

## Local Setup
1. Clone this repository
2. Install dependencies:
   ```sh
   dart pub get
   ```
3. Copy `.env.example` to `.env` and fill in secrets:
   ```sh
   cp .env.example .env
   ```
4. Run the server locally:
   ```sh
   dart run bin/flutter_mcp_server.dart
   ```

Or build and run with Docker:
   ```sh
   docker build -t flutter_mcp_server .
   docker run -it --env-file .env flutter_mcp_server
   ```

## Environment Variables
All sensitive data is managed via environment variables. See `.env.example` for required keys.

## Deployment to Smithery
- Ensure your `Dockerfile` and `smithery.yaml` are present and correct in the repository root.
- Connect your repository to Smithery via the Smithery web UI.
- Push your latest changes to trigger a new build.
- Configure environment variables in the Smithery deployment interface.
- Deploy and verify your MCP server using the Smithery MCP playground or compatible client.
