import 'package:test/test.dart';
import 'dart:io';
import 'package:mcp_server/mcp_server.dart';

void main() {
  group('Performance Benchmarks', () {
    Future<double> measureTool(
      String tool, [
      List<String> args = const [],
    ]) async {
      final sw = Stopwatch()..start();
      await Process.run('dart', [tool, ...args]);
      sw.stop();
      return sw.elapsedMilliseconds / 1000.0;
    }

    test('analyze tool performance', () async {
      final duration = await measureTool('analyze');
      print(
        'analyze completed in [32m[1m[4m${duration.toStringAsFixed(2)}s\u001b[0m',
      );
      expect(
        duration,
        lessThan(10.0),
        reason: 'analyze should complete in <10s',
      );
    });

    test('format tool performance', () async {
      final duration = await measureTool('format', ['.']);
      print(
        'format completed in [32m[1m[4m${duration.toStringAsFixed(2)}s\u001b[0m',
      );
      expect(
        duration,
        lessThan(10.0),
        reason: 'format should complete in <10s',
      );
    });

    test('test tool performance', () async {
      final duration = await measureTool('test');
      print(
        'test completed in [32m[1m[4m${duration.toStringAsFixed(2)}s\u001b[0m',
      );
      expect(duration, lessThan(20.0), reason: 'tests should complete in <20s');
    });
  });
}
