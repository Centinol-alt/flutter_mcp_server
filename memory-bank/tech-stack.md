# Tech Stack Document for MCP Server on Cloudflare for Flutter/Dart

This document details the technology stack for building and deploying an open-source Model Context Protocol (MCP) server for Flutter/Dart development, hosted on Cloudflare, with environment variable management for sensitive data.

## Programming Languages
- **Dart (≥3.4.4)**:
  - Primary language for the MCP server and tools.
  - Chosen for its compatibility with Flutter, strong typing, and async support.[](https://dart.dev/)
- **JavaScript/WebAssembly**:
  - Used for compiling Dart code to run on Cloudflare Workers.
  - Enables serverless execution in a browser-compatible format.

## Frameworks and Libraries
- **mcp_server (Dart package)**:
  - Implements MCP protocol (versions 2024-11-05, 2025-03-26).
  - Provides tools for server creation, tool registration, and caching.[](https://pub.dev/packages/mcp_server)
- **mcp_dart (Dart package)**:
  - SDK for MCP client and server development.
  - Simplifies protocol adherence and tool implementation.[](https://pub.dev/packages/mcp_dart)
- **dotenv**:
  - Loads environment variables from `.env` files during development.
  - Ensures secure handling of sensitive data locally.
- **logger**:
  - Provides debug, info, warning, and error logging.
  - Configurable for timestamp and color output.[](https://pub.dev/packages/mcp_server)
- **test**:
  - Dart package for unit and integration testing.
  - Validates tool functionality and protocol compliance.
- **shelf_plus**:
  - Optional for local HTTP server development during testing.
  - Simplifies request routing and handling.[](https://pieces.app/blog/how-to-build-a-server-in-dart)
- **dart_edge**:
  - Enables Dart execution in Cloudflare Workers.
  - Alternative to JavaScript/WebAssembly compilation.

## Infrastructure
- **Cloudflare Workers**:
  - Serverless platform for deploying the MCP server.
  - Provides global scalability, OAuth integration, and environment variable management.[](https://www.infoq.com/news/2025/04/cloudflare-remote-mcp-servers/)
- **Cloudflare Durable Objects**:
  - Used for stateful MCP server operations (e.g., session management).
  - Supports free tier with hibernation for cost efficiency.
- **Cloudflare Workers OAuth Provider**:
  - Implements OAuth 2.1 for secure user authentication and authorization.
  - Simplifies integration with external identity providers (e.g., Auth0, WorkOS).

## Development Tools
- **Visual Studio Code**:
  - Recommended IDE with Dart and Flutter extensions.
  - Supports code completion, debugging, and Flutter DevTools integration.[](https://codia.ai/docs/getting-started/setup-flutter-development-environment.html)
- **Cloudflare Wrangler CLI**:
  - Manages Worker deployment and secret configuration.
  - Used for local testing and production deployment.
- **Flutter SDK**:
  - Required for tool development (e.g., `flutter analyze`, `flutter format`).
  - Ensures compatibility with Flutter projects.[](https://mcp.so/server/flutter-tools)
- **Dart SDK**:
  - Core runtime for Dart tools and server execution.
  - Includes `dart pub` for package management.

## Version Control and Collaboration
- **Git**:
  - Manages source code versioning.
  - Hosted on GitHub for open-source collaboration.
- **GitHub**:
  - Hosts the repository, issues, and pull requests.
  - Supports community contributions and CI/CD workflows.
- **GitHub Actions**:
  - Automates testing and deployment pipelines.
  - Runs unit tests and lints on pull requests.

## Environment Variable Management
- **Development**:
  - `.env` file with `dotenv` package for local testing.
  - Example: `DART_TOKEN=your_token_here`.
- **Production**:
  - Cloudflare Workers secrets for sensitive data.
  - Configured via `wrangler secret put <KEY>`.
  - Example variables: `DART_TOKEN`, `CLOUDFLARE_API_KEY`, `OAUTH_CLIENT_SECRET`.

## Protocols and Standards
- **MCP Protocol (2024-11-05, 2025-03-26)**:
  - Standardizes AI-tool interactions.
  - Supports tools, resources, and prompts.[](https://pub.dev/packages/mcp_server)
- **OAuth 2.1**:
  - Secures user authentication and authorization.
  - Integrated via Cloudflare’s OAuth provider.[](https://blog.cloudflare.com/remote-model-context-protocol-servers-mcp/)
- **HTTP/REST**:
  - Used for client-server communication.
  - Supports JSON schemas for tool inputs/outputs.

## Deployment and Hosting
- **Cloudflare Workers**:
  - Primary hosting platform.
  - Supports serverless execution and global CDN.
- **Cloudflare Pages**:
  - Optional for hosting documentation or a web-based MCP client interface.
  - Integrates with EdgeOne Pages MCP service.[](https://mcp.so/server/dart-mcp-server/its-dart)

## Monitoring and Analytics
- **Cloudflare Analytics**:
  - Tracks Worker usage, response times, and errors.
  - Provides insights for performance optimization.
- **Custom Metrics**:
  - Implemented via `mcp_server`’s metric tracking (e.g., `server.incrementMetric('api_calls')`).[](https://pub.dev/packages/mcp_server)

## Open-Source Dependencies
- All dependencies are open-source (MIT or compatible licenses).
- Key packages (`mcp_server`, `mcp_dart`, `dotenv`, `logger`) are actively maintained on `pub.dev`.

This tech stack ensures a scalable, secure, and maintainable MCP server, optimized for Flutter/Dart development and Cloudflare deployment, with robust environment variable management and open-source compatibility.