import 'dart:io';
import 'package:args/args.dart';
import 'package:ssr_cli/src/commands/create.dart';
import 'package:ssr_cli/src/commands/generate.dart';
import 'package:ssr_cli/src/commands/build.dart';
import 'package:ssr_cli/src/commands/serve.dart';

void main(List<String> arguments) async {
  final createCmd = CreateCommand();
  final generateCmd = GenerateCommand();
  final buildCmd = BuildCommand();
  final serveCmd = ServeCommand();

  final parser = ArgParser();
  
  final createParser = parser.addCommand('create');
  createParser.addOption('template', abbr: 't', defaultsTo: 'basic', help: 'Project template');
  createParser.addFlag('force', abbr: 'f', negatable: false, help: 'Force overwrite');
  createParser.addFlag('help', abbr: 'h', negatable: false);
  
  final generateParser = parser.addCommand('generate');
  generateParser.addCommand('page');
  generateParser.addCommand('component');
  generateParser.addCommand('service');
  generateParser.addFlag('help', abbr: 'h', negatable: false);
  
  final buildParser = parser.addCommand('build');
  buildParser.addFlag('release', abbr: 'r', negatable: false, help: 'Release mode');
  buildParser.addFlag('help', abbr: 'h', negatable: false);
  
  final serveParser = parser.addCommand('serve');
  serveParser.addOption('port', abbr: 'p', defaultsTo: '3000', help: 'Server port');
  serveParser.addFlag('help', abbr: 'h', negatable: false);
  
  parser.addFlag('help', abbr: 'h', negatable: false, help: 'Show help');

  try {
    final results = parser.parse(arguments);

    if (results['help'] as bool || results.command == null) {
      _printUsage(parser);
      return;
    }

    switch (results.command!.name) {
      case 'create':
        await createCmd.run(results.command!);
        break;
      case 'generate':
        await generateCmd.run(results.command!);
        break;
      case 'build':
        await buildCmd.run(results.command!);
        break;
      case 'serve':
        await serveCmd.run(results.command!);
        break;
      default:
        _printUsage(parser);
    }
  } on FormatException catch (e) {
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
