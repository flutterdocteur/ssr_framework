import 'dart:io';
import 'package:args/args.dart';

class ServeCommand {
  ArgParser get parser => ArgParser()
    ..addOption('port',
        abbr: 'p',
        defaultsTo: '3000',
        help: 'Port to run the server on')
    ..addFlag('help', abbr: 'h', negatable: false);

  Future<void> run(ArgResults results) async {
    if (results['help'] as bool) {
      _printUsage();
      return;
    }

    final port = results['port'] as String;

    print('Starting development server on port $port...');
    print('');

    // Set environment variable for port
    final env = Map<String, String>.from(Platform.environment);
    env['PORT'] = port;

    // Run the server
    final serverProcess = await Process.start(
      'dart',
      ['run', 'bin/server.dart'],
      environment: env,
    );

    // Forward stdout and stderr
    serverProcess.stdout.listen((data) {
      stdout.add(data);
    });

    serverProcess.stderr.listen((data) {
      stderr.add(data);
    });

    // Handle process termination
    ProcessSignal.sigint.watch().listen((_) {
      serverProcess.kill();
      exit(0);
    });

    // Wait for the process to exit
    final exitCode = await serverProcess.exitCode;
    exit(exitCode);
  }

  void _printUsage() {
    print('Start the development server');
    print('');
    print('Usage: ssr serve [options]');
    print('');
    print('Options:');
    print('  -p, --port <port>    Port to run the server on (default: 3000)');
    print('  -h, --help           Show this help');
    print('');
    print('Example:');
    print('  ssr serve --port 8080');
  }
}
