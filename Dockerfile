# Dockerfile for Flutter MCP Server (Dart, Smithery-ready)
FROM dart:stable AS build
WORKDIR /app
COPY . .
RUN dart pub get
RUN dart compile exe bin/flutter_mcp_server.dart -o bin/server

# Runtime stage (smaller image)
FROM debian:stable-slim AS runtime
WORKDIR /app
COPY --from=build /app/bin/server /app/bin/server
COPY --from=build /app/.env.example /app/.env.example
COPY --from=build /app/pubspec.yaml /app/pubspec.yaml
COPY --from=build /app/pubspec.lock /app/pubspec.lock
COPY --from=build /app/lib /app/lib
COPY --from=build /app/bin /app/bin
ENV PATH="/app/bin:$PATH"
# Entrypoint for stdio MCP server
ENTRYPOINT ["/app/bin/server"]
