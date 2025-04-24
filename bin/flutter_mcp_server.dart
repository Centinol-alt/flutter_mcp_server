import 'package:mcp_server/mcp_server.dart';
import 'package:dotenv/dotenv.dart';
import 'package:logger/logger.dart' as ext_logger;

Future<void> main(List<String> arguments) async {
  // Load environment variables (optional, for local dev)
  final dotEnv = DotEnv()..load();

  final logger = ext_logger.Logger();
  final server = McpServer.createServer(
    name: 'Flutter MCP Server',
    version: '1.0.0',
    capabilities: ServerCapabilities(
      tools: true,
      resources: true, // Enable resources capability
      prompts: false,
    ),
  );

// Register tools
import 'dart:io';

// Register real MCP tools
void registerMcpTools() {
  // Analyze
  server.addTool(
    name: 'analyze',
    description: 'Analyze Dart code using dart analyze',
    inputSchema: {'type': 'object'},
    handler: (input) async {
      logger.i('Running analyze tool');
      final result = await Process.run('dart', ['analyze']);
      final output = result.stdout.toString() + result.stderr.toString();
      return CallToolResult([
        TextContent(text: output)
      ]);
    },
  );

  // Format
  server.addTool(
    name: 'format',
    description: 'Format Dart code using dart format',
    inputSchema: {
      'type': 'object',
      'properties': {
        'path': {'type': 'string', 'description': 'File or directory to format'}
      },
      'required': []
    },
    handler: (input) async {
      logger.i('Running format tool');
      final path = input['path']?.toString() ?? '.';
      final result = await Process.run('dart', ['format', path]);
      final output = result.stdout.toString() + result.stderr.toString();
      return CallToolResult([
        TextContent(text: output)
      ]);
    },
  );

  // Fix
  server.addTool(
    name: 'fix',
    description: 'Apply Dart fixes using dart fix --apply',
    inputSchema: {'type': 'object'},
    handler: (input) async {
      logger.i('Running fix tool');
      final result = await Process.run('dart', ['fix', '--apply']);
      final output = result.stdout.toString() + result.stderr.toString();
      return CallToolResult([
        TextContent(text: output)
      ]);
    },
  );

  // Create
  server.addTool(
    name: 'create',
    description: 'Create a new Dart or Flutter project',
    inputSchema: {
      'type': 'object',
      'properties': {
        'template': {'type': 'string', 'description': 'Project template (console, package, flutter, etc.)'},
        'path': {'type': 'string', 'description': 'Directory to create project in'}
      },
      'required': ['path']
    },
    handler: (input) async {
      logger.i('Running create tool');
      final template = input['template']?.toString();
      final path = input['path']?.toString() ?? 'new_project';
      final args = <String>['create'];
      if (template != null) args.addAll(['-t', template]);
      args.add(path);
      final result = await Process.run('dart', args);
      final output = result.stdout.toString() + result.stderr.toString();
      return CallToolResult([
        TextContent(text: output)
      ]);
    },
  );

  // Run
  server.addTool(
    name: 'run',
    description: 'Run a Dart or Flutter app',
    inputSchema: {
      'type': 'object',
      'properties': {
        'entrypoint': {'type': 'string', 'description': 'Entrypoint file (main.dart) or directory'}
      },
      'required': []
    },
    handler: (input) async {
      logger.i('Running run tool');
      final entrypoint = input['entrypoint']?.toString();
      final args = <String>['run'];
      if (entrypoint != null) args.add(entrypoint);
      final result = await Process.run('dart', args);
      final output = result.stdout.toString() + result.stderr.toString();
      return CallToolResult([
        TextContent(text: output)
      ]);
    },
  );

  // Test
  server.addTool(
    name: 'test',
    description: 'Run Dart tests',
    inputSchema: {
      'type': 'object',
      'properties': {
        'path': {'type': 'string', 'description': 'Test file or directory'}
      },
      'required': []
    },
    handler: (input) async {
      logger.i('Running test tool');
      final path = input['path']?.toString();
      final args = <String>['test'];
      if (path != null) args.add(path);
      final result = await Process.run('dart', args);
      final output = result.stdout.toString() + result.stderr.toString();
      return CallToolResult([
        TextContent(text: output)
      ]);
    },
  );

  // get_diagnostics (alias for analyze)
  server.addTool(
    name: 'get_diagnostics',
    description: 'Get diagnostics for Dart/Flutter code (alias for analyze)',
    inputSchema: {'type': 'object'},
    handler: (input) async {
      logger.i('Running get_diagnostics tool');
      final result = await Process.run('dart', ['analyze']);
      final output = result.stdout.toString() + result.stderr.toString();
      return CallToolResult([
        TextContent(text: output)
      ]);
    },
  );

  // apply_fixes (alias for fix)
  server.addTool(
    name: 'apply_fixes',
    description: 'Apply fixes to Dart code (alias for fix)',
    inputSchema: {'type': 'object'},
    handler: (input) async {
      logger.i('Running apply_fixes tool');
      final result = await Process.run('dart', ['fix', '--apply']);
      final output = result.stdout.toString() + result.stderr.toString();
      return CallToolResult([
        TextContent(text: output)
      ]);
    },
  );

  // flutter_inspector (stub, as it requires DevTools integration)
  server.addTool(
    name: 'flutter_inspector',
    description: 'Flutter Inspector integration (requires DevTools, stub)',
    inputSchema: {'type': 'object'},
    handler: (input) async {
      logger.i('Running flutter_inspector tool');
      return CallToolResult([
        TextContent(text: 'Flutter Inspector is not implemented in this server. Use DevTools for widget inspection.')
      ]);
    },
  );
}

registerMcpTools();

// --- Resource caching example ---
final Map<String, String> _resourceCache = {};

server.addResource(
  name: 'example_resource',
  description: 'Returns a static value, cached for repeated queries.',
  inputSchema: {
    'type': 'object',
    'properties': {
      'query': {'type': 'string', 'description': 'The resource query'}
    },
    'required': ['query']
  },
  handler: (input) async {
    final query = input['query'] as String;
    if (_resourceCache.containsKey(query)) {
      return ResourceResult([
        TextContent(text: '[CACHED] ' + _resourceCache[query]!)
      ]);
    }
    // Simulate a slow resource fetch
    await Future.delayed(Duration(milliseconds: 500));
    final value = 'Resource value for query: $query';
    _resourceCache[query] = value;
    return ResourceResult([
      TextContent(text: value)
    ]);
  },
);

// --- Phase 5: Real resource endpoints for LLMs ---
final Map<String, String> _newsCache = {};
final Map<String, String> _docCache = {};
final Map<String, String> _exampleCache = {};

server.addResource(
  name: 'flutter_news_resource',
  description: 'Fetches the latest Flutter/Dart news headlines and changelogs.',
  inputSchema: {
    'type': 'object',
    'properties': {
      'topic': {'type': 'string', 'description': 'Topic (flutter, dart, changelog, etc.)'}
    },
    'required': ['topic']
  },
  handler: (input) async {
    final topic = input['topic'] as String;
    if (_newsCache.containsKey(topic)) {
      return ResourceResult([
        TextContent(text: '[CACHED] ' + _newsCache[topic]!)
      ]);
    }
    // For demo: fetch from public URLs (could use http package for real fetch)
    String news = '';
    if (topic.toLowerCase().contains('flutter')) {
      news = 'See https://docs.flutter.dev/release/whats-new for Flutter news.';
    } else if (topic.toLowerCase().contains('dart')) {
      news = 'See https://dart.dev/guides/whats-new for Dart news.';
    } else if (topic.toLowerCase().contains('changelog')) {
      news = 'See https://github.com/flutter/flutter/releases for changelogs.';
    } else {
      news = 'No news found for topic: $topic.';
    }
    _newsCache[topic] = news;
    return ResourceResult([
      TextContent(text: news)
    ]);
  },
);

server.addResource(
  name: 'dart_doc_resource',
  description: 'Returns official documentation links and summaries for Dart/Flutter topics.',
  inputSchema: {
    'type': 'object',
    'properties': {
      'query': {'type': 'string', 'description': 'Documentation topic or keyword'}
    },
    'required': ['query']
  },
  handler: (input) async {
    final query = input['query'] as String;
    if (_docCache.containsKey(query)) {
      return ResourceResult([
        TextContent(text: '[CACHED] ' + _docCache[query]!)
      ]);
    }
    // For demo: simple keyword matching
    String doc = '';
    if (query.toLowerCase().contains('http')) {
      doc = 'Dart http docs: https://pub.dev/packages/http';
    } else if (query.toLowerCase().contains('state')) {
      doc = 'Flutter state management: https://docs.flutter.dev/data-and-backend/state-mgmt/options';
    } else {
      doc = 'Try searching https://dart.dev or https://docs.flutter.dev for "$query".';
    }
    _docCache[query] = doc;
    return ResourceResult([
      TextContent(text: doc)
    ]);
  },
);

server.addResource(
  name: 'community_examples_resource',
  description: 'Returns links to community-curated code examples and patterns.',
  inputSchema: {
    'type': 'object',
    'properties': {
      'topic': {'type': 'string', 'description': 'Example topic (e.g., bloc, provider, navigation)'}
    },
    'required': ['topic']
  },
  handler: (input) async {
    final topic = input['topic'] as String;
    if (_exampleCache.containsKey(topic)) {
      return ResourceResult([
        TextContent(text: '[CACHED] ' + _exampleCache[topic]!)
      ]);
    }
    // For demo: simple topic matching
    String example = '';
    if (topic.toLowerCase().contains('bloc')) {
      example = 'See https://bloclibrary.dev/#/ for Bloc pattern examples.';
    } else if (topic.toLowerCase().contains('provider')) {
      example = 'See https://pub.dev/packages/provider for Provider examples.';
    } else if (topic.toLowerCase().contains('navigation')) {
      example = 'Flutter navigation: https://docs.flutter.dev/ui/navigation';
    } else {
      example = 'Try https://flutterawesome.com or https://pub.dev for "$topic".';
    }
    _exampleCache[topic] = example;
    return ResourceResult([
      TextContent(text: example)
    ]);
  },
);

// --- Phase 5: Natural language search tool for docs/resources ---
server.addTool(
  name: 'search_docs',
  description: 'Searches official and community docs/resources for a natural language query.',
  inputSchema: {
    'type': 'object',
    'properties': {
      'query': {'type': 'string', 'description': 'Natural language query'}
    },
    'required': ['query']
  },
  handler: (input) async {
    final query = input['query'] as String;
    // For demo: simple keyword-based aggregation
    final List<String> results = [];
    // News
    if (_newsCache.containsKey(query)) results.add(_newsCache[query]!);
    // Docs
    if (_docCache.containsKey(query)) results.add(_docCache[query]!);
    // Examples
    if (_exampleCache.containsKey(query)) results.add(_exampleCache[query]!);
    // Fallback
    if (results.isEmpty) {
      results.add('No cached result. Try https://dart.dev/search?q=${Uri.encodeComponent(query)} or https://docs.flutter.dev/search?q=${Uri.encodeComponent(query)}');
    }
    return CallToolResult([
      TextContent(text: results.join('\n---\n'))
    ]);
  },
);

// Start the server (stdio)
final transport = McpServer.createStdioTransport();
server.connect(transport);
}
