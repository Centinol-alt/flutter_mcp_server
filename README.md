# Flutter MCP Server

> **Note:** Smithery cloud deployment is not currently set up. This MCP server is only supported for local use at this time. Smithery integration and registry listing are not yet available.

## Overview

The **Flutter MCP Server** is an open-source implementation of the Model Context Protocol (MCP) for the Dart and Flutter ecosystem. It acts as a bridge between AI assistants, developer tools, and automated workflows, enabling secure, programmable, and context-aware automation of Dart and Flutter development tasks.

### What does this MCP server do?

- **Exposes Dart & Flutter SDK tools** (analyze, format, fix, create, run, test) as programmable endpoints, allowing AI agents, scripts, or remote clients to invoke them via the MCP protocol.
- **Provides a unified API** for code analysis, formatting, project scaffolding, running tests, and more—remotely and securely.
- **Manages environment variables securely** using best practices, ensuring secrets and configuration are not exposed.
- **Supports resource endpoints** for documentation lookup, news, and community examples, making it easy for AI clients to retrieve relevant information for Dart/Flutter projects.
- **Designed for integration** with platforms like Smithery, but can be run locally or in any Docker-compatible environment.

### What problems does it solve?

- **Bridges the gap between AI and code:** Enables AI-powered tools (like code assistants, chatbots, or CI agents) to interact with real Dart/Flutter projects, run tools, and fetch context programmatically.
- **Automates repetitive tasks:** Developers and teams can automate code formatting, analysis, testing, and project creation through a single, secure interface.
- **Standardizes tool invocation:** Removes the need for custom scripts or manual tool execution—everything is exposed via a consistent, discoverable API.
- **Enables remote and cloud workflows:** Can be deployed in CI/CD, cloud platforms, or as part of a larger AI-driven development pipeline.
- **Promotes best practices:** Handles secrets via environment variables, supports containerized deployment, and follows open standards for protocol and API design.

### Full Functionality

- **Tool Endpoints:** Invoke `analyze`, `format`, `fix`, `create`, `run`, `test`, and other Dart/Flutter commands via MCP.
- **Resource Endpoints:** Query for documentation, news, and curated community examples.
- **Logging:** All tool invocations are logged for observability and debugging.
- **Docker Support:** Easily build and run in a containerized environment for reproducibility and security.
- **Extensible:** Add new tools and resources as needed, adapting to evolving workflows and community feedback.

## Features
- Exposes Dart and Flutter SDK tools (analyze, format, fix, create, run, test)
- Supports MCP protocol for AI assistants
- Secure environment variable management
- Smithery Registry integration
- Ready-to-deploy Dockerfile and smithery.yaml for Smithery

## Documentation

- See the [`docs/`](docs/README.md) folder for detailed setup, tool descriptions, deployment, and AI client integration guides.
- See [`CONTRIBUTING.md`](CONTRIBUTING.md) for contribution guidelines.

## Getting Started

### Prerequisites
- Dart SDK (≥3.4.4)
- Flutter SDK
- Docker (for local container builds and Smithery deployment)
- Smithery account (for cloud deployment)

### Local Setup
1. Clone this repository
2. Install dependencies:
   ```sh
   dart pub get
   ```
3. Copy `.env.example` to `.env` and fill in secrets:
   ```sh
   cp .env.example .env
   ```
4. Run the server locally (example):
   ```sh
   dart run bin/flutter_mcp_server.dart
   ```

Or build and run with Docker:
   ```sh
   docker build -t flutter_mcp_server .
   docker run -it --env-file .env flutter_mcp_server
   ```

### Environment Variables
All sensitive data is managed via environment variables. See `.env.example` for required keys.

---

### Adding the MCP Server to Clients

#### Adding the MCP Server to Windsurf
To use this MCP server with [Windsurf](https://github.com/CodeiumAI/windsurf), add the following entry to your `.codeium/windsurf/mcp_config.json`:

```json
{
  "mcpServers": {
    "flutter_mcp_server": {
      "command": "docker",
      "args": [
        "run",
        "--rm",
        "-i",
        "flutter_mcp_server"
      ]
    }
  }
}
```

This tells Windsurf how to launch your MCP server using Docker. Adjust the image name if needed.

#### Adding the MCP Server to Cursor mcp.json
If you use [Cursor](https://www.cursor.so/) or another client that supports a `mcp.json` config, add your server like this:

```json
{
  "servers": [
    {
      "name": "Flutter MCP Server",
      "command": "docker",
      "args": [
        "run",
        "--rm",
        "-i",
        "flutter_mcp_server"
      ],
      "env": {
        // Add any required environment variables here
      }
    }
  ]
}
```

This enables Cursor or compatible clients to start and connect to your MCP server automatically.

---

### Deployment (Smithery)
- Ensure your `Dockerfile` and `smithery.yaml` are present and correct in the repository root.
- Connect your repository to Smithery via the Smithery web UI.
- Push your latest changes to trigger a new build.
- Configure environment variables in the Smithery deployment interface.
- Deploy and verify your MCP server using the Smithery MCP playground or compatible client.

## Publishing to pub.dev (not currently set up)

This package is intended to be published to [pub.dev](https://pub.dev/). Ensure your `pubspec.yaml` is up to date and run:

```sh
dart pub publish
```

See the [official guide](https://dart.dev/tools/pub/publishing) for details.

## License
[MIT](LICENSE)
