# Smithery Deployments Documentation

## Overview
Smithery Deployments enable hosting of stdio-based Model Context Protocol (MCP) servers over WebSocket connections, eliminating the need for local installation while maintaining security.

## Key Features
- WebSocket-based hosting for stdio MCP servers
- Built-in MCP playground for testing
- Higher search result ranking for hosted servers
- Serverless environment with 5-minute idle timeout
- Session affinity through WebSockets

## Deployment Process
1. Add server to Smithery (or claim existing server)
2. Access Deployments tab (authenticated owners only)
3. Configure and deploy

## Technical Specifications
- Transport: WebSocket (WS)
- Storage: Ephemeral (persistent data requires external database)

## Other Notes
- WebSockets chosen for session affinity in scaled environments
- Server-Sent-Events not supported for hosting

## Best Practices
- Server initialization: The `initialize` method must be accessible without API keys or configurations
- Tools List: The `/tools/list` endpoint must be accessible without API keys or configurations
- Handle WebSocket reconnection
- Design for ephemeral storage
- Use external databases for persistent data

## Configuration Requirements

### Required Files
Two essential files needed for deployment:
1. Dockerfile - Defines server build process
2. smithery.yaml - Defines server startup configuration

### Dockerfile Requirements
- Must be placed in repository root (or subdirectory for monorepos)
- Must build a Linux-based image (Alpine/Debian-based)
- Must support `sh` shell execution
- Should be tested locally before deployment

Example Dockerfile (Node.js):
```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build
CMD ["node", "dist/index.js"]
```

### smithery.yaml Configuration
Required structure:
```yaml
startCommand:
  type: stdio
  configSchema: {}  # JSON Schema for configuration options
  commandFunction: |
    (config) => ({
      "command": "node",
      "args": ["dist/index.js"],
      "env": {}
    })
```

Configuration Components:
- `type`: Must be "stdio" for standard I/O based MCP server
- `configSchema`: JSON Schema defining valid configuration options
- `commandFunction`: JavaScript function returning command details
  - Returns: command, arguments, environment variables
  - Runs in server sandbox during runtime
  - Receives validated config input

Optional Configuration:
- `build`: Build configuration object
  - `dockerfile`: Path to Dockerfile (relative to config)
  - `dockerBuildPath`: Docker build context path

### Monorepo Support
For monorepos:
1. Place Dockerfile and smithery.yaml in package subdirectory
2. Set base directory in Smithery server settings
3. Example: `packages/mcp-server/` for subdirectory deployment

### Configuration Best Practices
1. **Testing**
   - Test locally using MCP Inspector
   - Verify Dockerfile builds successfully
   - CLI Testing Commands:
     ```bash
     # Test local server
     npx @wong2/mcp-cli node path/to/server/index.js

     # Test any executable
     npx @wong2/mcp-cli <executable> <args>
     
     # Examples:
     npx @wong2/mcp-cli python script.py
     npx @wong2/mcp-cli go run main.go
     npx @wong2/mcp-cli npx <package-name> <args>
     npx @wong2/mcp-cli uvx <package-name> <args>

     # Visual testing
     npx @modelcontextprotocol/inspector node build/index.js
     npx @modelcontextprotocol/inspector python script.py
     npx @modelcontextprotocol/inspector go run main.go
     npx @modelcontextprotocol/inspector npx <package-name> <args>
     npx @modelcontextprotocol/inspector uvx <package-name> <args>
     ```
2. **Configuration**
   - Use configSchema for proper validation
   - Define clear configuration options
3. **Docker Optimization**
   - Minimize image size
   - Use appropriate base images
   - Consider multi-stage builds

## Configuration Examples

### 1. Basic Configuration (No Required Parameters)
```yaml
startCommand:
  type: stdio
  configSchema:
    type: object
    properties: {}
  commandFunction: |
    (config) => ({ 
      command: 'python', 
      args: ['-m', 'duckduckgo_mcp_server.server'] 
    })
```

### 2. API Key Configuration (Brave Search)
```yaml
build:
  dockerBuildPath: ../../
startCommand:
  type: stdio
  configSchema:
    type: object
    required:
      - braveApiKey
    properties:
      braveApiKey:
        type: string
        description: The API key for the BRAVE Search server.
  commandFunction: |
    config => ({
      command: 'node',
      args: ['dist/index.js'],
      env: { BRAVE_API_KEY: config.braveApiKey }
    })
```

### 3. GitHub Integration
```yaml
build:
  dockerBuildPath: ../../
startCommand:
  type: stdio
  configSchema:
    type: object
    required:
      - githubPersonalAccessToken
    properties:
      githubPersonalAccessToken:
        type: string
        description: The personal access token for accessing the GitHub API.
  commandFunction: |
    (config) => ({ 
      command: 'node', 
      args: ['dist/index.js'], 
      env: { GITHUB_PERSONAL_ACCESS_TOKEN: config.githubPersonalAccessToken } 
    })
```

### 4. Database Connection
```yaml
build:
  dockerfile: Dockerfile-smithery.build
startCommand:
  type: stdio
  configSchema:
    type: object
    required:
      - ConnectionString
    properties:
      ConnectionString:
        type: string
        description: Connection string for the database
  commandFunction: |
    (config) => ({ 
      command: 'gateway', 
      args: ['start', '--raw=true', '--connection-string', config.ConnectionString, 'mcp-stdio'],
      env: {}
    })
```

### 5. Custom Dockerfile Path
```yaml
build:
  dockerfile: ./docker/Dockerfile.prod  # Custom Dockerfile path
  dockerBuildPath: ./docker  # Build context relative to smithery.yaml
startCommand:
  type: stdio
  configSchema:
    type: object
    required:
      - apiKey
    properties:
      apiKey:
        type: string
        description: API key for the service
  commandFunction: |
    (config) => ({
      command: 'node',
      args: ['dist/index.js'],
      env: { API_KEY: config.apiKey }
    })
```

## Key Concepts

### 1. Configuration Structure
- Every configuration must have a `startCommand` object
- `type` must always be "stdio"
- `configSchema` defines what parameters are required/optional
- `commandFunction` generates the actual command to run

### 2. Environment Variables
- Use `env` in `commandFunction` to pass sensitive data
- Environment variables are the recommended way to handle API keys
- Never hardcode sensitive information in the configuration

### 3. Build Configuration
- `dockerBuildPath` is used when files are in a different directory
- `dockerfile` can specify a custom Dockerfile name and path
- Build context is important for monorepo setups
- Dockerfile path is relative to the build context
- Example paths:
  - `./docker/Dockerfile.prod` - Custom Dockerfile in subdirectory
  - `Dockerfile-smithery.build` - Custom Dockerfile in same directory
  - `../Dockerfile` - Dockerfile in parent directory

### 4. Schema Validation
- `configSchema` uses JSON Schema format
- `required` array lists mandatory parameters
- `properties` defines parameter types and descriptions
- Schema validation happens before deployment

### 5. Command Generation
- `commandFunction` is a JavaScript function
- Receives validated config as input
- Returns object with command, args, and env
- Can use template literals and string manipulation

## Dockerfile Examples

### 1. Multi-stage Go Build with UPX Compression
```dockerfile
# Builder stage: build in Debian environment
FROM golang:1.24-bullseye AS builder

WORKDIR /app

# Install necessary build tools and UPX
RUN apt-get update && \
    apt-get install -y --no-install-recommends git gcc build-essential upx && \
    rm -rf /var/lib/apt/lists/*

# Copy module files and download dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy source code
COPY . .

# Build binary with CGO enabled
RUN CGO_ENABLED=1 GOOS=linux go build -ldflags="-w -s" -o gateway

# Compress binary using UPX
RUN upx --best --lzma gateway

# Final stage: minimal Debian-based image
FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install minimal dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends tzdata ca-certificates && \
    rm -rf /var/lib/apt/lists/* && \
    ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    echo "Etc/UTC" > /etc/timezone && \
    groupadd --system gateway && \
    useradd --system --create-home --home-dir /home/gateway --gid gateway gateway

# Set environment variables
ENV TZ=Etc/UTC
ENV ROTATION_TZ=Etc/UTC
ENV HOME=/home/gateway

# Copy compiled binary from build stage
COPY --from=builder /app/gateway /usr/local/bin/gateway

# Switch to non-privileged user
USER gateway

ENTRYPOINT ["/usr/local/bin/gateway"]
```

### 2. Node.js Single Stage Build
```dockerfile
FROM node:lts-alpine

# Create app directory
WORKDIR /usr/src/app

# Copy package files
COPY package*.json ./

# Install dependencies without triggering scripts
RUN npm install --ignore-scripts

# Copy source code
COPY . .

# Build the application
RUN npm run build

# Run the server
CMD [ "node", "dist/index.js" ]
```

### 3. Node.js Multi-stage Build with Cache
```dockerfile
FROM node:22.12-alpine AS builder

COPY src/sequentialthinking /app
COPY tsconfig.json /tsconfig.json

WORKDIR /app

# Use cache for npm install
RUN --mount=type=cache,target=/root/.npm npm install
RUN --mount=type=cache,target=/root/.npm-production npm ci --ignore-scripts --omit-dev

# Final stage
FROM node:22-alpine AS release

# Copy only necessary files
COPY --from=builder /app/dist /app/dist
COPY --from=builder /app/package.json /app/package.json
COPY --from=builder /app/package-lock.json /app/package-lock.json

ENV NODE_ENV=production

WORKDIR /app

RUN npm ci --ignore-scripts --omit-dev

ENTRYPOINT ["node", "dist/index.js"]
```

### 4. Python Alpine Build
```dockerfile
FROM python:3.11-alpine

# Install system dependencies
RUN apk add --no-cache gcc musl-dev linux-headers

# Set working directory
WORKDIR /app

# Copy all files
COPY . /app

# Install Python dependencies
RUN pip install --upgrade pip \
    && pip install --no-cache-dir .

# Run the MCP server
CMD ["python", "-m", "duckduckgo_mcp_server.server"]
```

## Dockerfile Best Practices

### 1. Multi-stage Builds
- Use separate build and runtime stages
- Copy only necessary files to final image
- Minimize final image size
- Example: Go build with UPX compression

### 2. Security
- Use non-root users
- Remove unnecessary tools
- Clean up package caches
- Example: Go build with gateway user

### 3. Caching
- Leverage Docker layer caching
- Use build cache mounts
- Copy dependency files first
- Example: Node.js multi-stage build

### 4. Optimization
- Use appropriate base images
- Minimize layers
- Remove unnecessary files
- Example: Python Alpine build

### 5. Environment Setup
- Set proper working directories
- Configure timezones
- Set environment variables
- Example: Go build with timezone config