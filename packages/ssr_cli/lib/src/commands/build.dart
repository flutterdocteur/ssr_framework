import 'dart:io';
import 'package:args/args.dart';

class BuildCommand {
  ArgParser get parser => ArgParser()
    ..addFlag('release',
        abbr: 'r',
        negatable: false,
        help: 'Build in release mode')
    ..addFlag('help', abbr: 'h', negatable: false);

  Future<void> run(ArgResults results) async {
    if (results['help'] as bool) {
      _printUsage();
      return;
    }

    final release = results['release'] as bool;
    final mode = release ? 'release' : 'development';

    print('Building project in $mode mode...');
    print('');

    // Run build_runner
    final buildArgs = ['run', 'build_runner', 'build'];
    if (release) {
      buildArgs.add('--release');
    }
    buildArgs.add('--delete-conflicting-outputs');

    final buildResult = await Process.run('dart', buildArgs);

    if (buildResult.exitCode != 0) {
      stderr.writeln('Build failed:');
      stderr.writeln(buildResult.stderr);
      exit(1);
    }

    print('✓ Client built successfully');

    // Copy built files to public directory
    print('');
    print('Copying built files to public directory...');

    final sourceDir = Directory('.dart_tool/build/generated/${_getProjectName()}/web');

    if (!await sourceDir.exists()) {
      stderr.writeln('Error: Build output directory not found');
      exit(1);
    }

    await for (final entity in sourceDir.list()) {
      if (entity is File) {
        final fileName = entity.uri.pathSegments.last;
        final targetFile = File('public/$fileName');
        await entity.copy(targetFile.path);
        print('  ✓ Copied $fileName');
      }
    }

    print('');
    print('✓ Build completed successfully!');
    print('');
    print('To start the server:');
    print('  dart run bin/server.dart');
  }

  void _printUsage() {
    print('Build the project for production');
    print('');
    print('Usage: ssr build [options]');
    print('');
    print('Options:');
    print('  -r, --release    Build in release mode (default: development)');
    print('  -h, --help       Show this help');
  }

  String _getProjectName() {
    final pubspecFile = File('pubspec.yaml');
    if (!pubspecFile.existsSync()) {
      return 'app';
    }

    final content = pubspecFile.readAsStringSync();
    final match = RegExp(r'name:\s*(.+)').firstMatch(content);
    if (match != null) {
      return match.group(1)!.trim();
    }
    return 'app';
  }
}
