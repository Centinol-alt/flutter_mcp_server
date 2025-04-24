

# Flutter MCP Server

This project implements an open-source Model Context Protocol (MCP) server for Flutter/Dart development, designed for deployment on Smithery and discoverability via the Smithery Registry. It exposes Dart/Flutter tools for AI-driven workflows and ensures secure handling of environment variables.

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

### Deployment (Smithery)
- Ensure your `Dockerfile` and `smithery.yaml` are present and correct in the repository root.
- Connect your repository to Smithery via the Smithery web UI.
- Push your latest changes to trigger a new build.
- Configure environment variables in the Smithery deployment interface.
- Deploy and verify your MCP server using the Smithery MCP playground or compatible client.

## Publishing to pub.dev

This package is intended to be published to [pub.dev](https://pub.dev/). Ensure your `pubspec.yaml` is up to date and run:

```sh
dart pub publish
```

See the [official guide](https://dart.dev/tools/pub/publishing) for details.

## License
[MIT](LICENSE)
