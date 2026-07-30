import 'dart:io';
import 'package:args/args.dart';
import 'package:ssr_cli/src/commands/create.dart';
import 'package:ssr_cli/src/commands/generate.dart';
import 'package:ssr_cli/src/commands/build.dart';
import 'package:ssr_cli/src/commands/serve.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addCommand('create')
    ..addCommand('generate')
    ..addCommand('build')
    ..addCommand('serve')
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show help');

  try {
    final results = parser.parse(arguments);

    if (results['help'] as bool || results.command == null) {
      _printUsage(parser);
      return;
    }

    switch (results.command!.name) {
      case 'create':
        await CreateCommand().run(results.command!);
        break;
      case 'generate':
        await GenerateCommand().run(results.command!);
        break;
      case 'build':
        await BuildCommand().run(results.command!);
        break;
      case 'serve':
        await ServeCommand().run(results.command!);
        break;
      default:
        _printUsage(parser);
    }
  } catch (FormatException e) {
    stderr.writeln('Error: ${e.message}');
    _printUsage(parser);
    exit(1);
  }
}

void _printUsage(ArgParser parser) {
  print('SSR Framework CLI');
  print('');
  print('Usage: ssr <command> [arguments]');
  print('');
  print('Available commands:');
  print('  create    Create a new SSR project');
  print('  generate  Generate pages, components, or services');
  print('  build     Build the project for production');
  print('  serve     Start the development server');
  print('');
  print('Run "ssr <command> --help" for more information about a command.');
}
