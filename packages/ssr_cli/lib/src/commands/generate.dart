import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;

class GenerateCommand {
  ArgParser get parser => ArgParser()
    ..addCommand('page')
    ..addCommand('component')
    ..addCommand('service')
    ..addFlag('help', abbr: 'h', negatable: false);

  Future<void> run(ArgResults results) async {
    if (results.command == null || results['help'] as bool) {
      _printUsage();
      return;
    }

    switch (results.command!.name) {
      case 'page':
        await _generatePage(results.command!);
        break;
      case 'component':
        await _generateComponent(results.command!);
        break;
      case 'service':
        await _generateService(results.command!);
        break;
      default:
        _printUsage();
    }
  }

  void _printUsage() {
    print('Generate pages, components, or services');
    print('');
    print('Usage: ssr generate <type> <name>');
    print('');
    print('Available types:');
    print('  page       Generate a new page');
    print('  component  Generate a new component');
    print('  service    Generate a new service');
    print('');
    print('Examples:');
    print('  ssr generate page profile');
    print('  ssr generate component user-card');
    print('  ssr generate service auth');
  }

  Future<void> _generatePage(ArgResults results) async {
    if (results.rest.isEmpty) {
      stderr.writeln('Error: Page name is required');
      stderr.writeln('Usage: ssr generate page <name>');
      exit(1);
    }

    final name = results.rest.first;
    final className = _toPascalCase(name);
    final fileName = _toSnakeCase(name);

    // Create page class
    final pageContent = '''
import 'package:ssr_core/ssr_core.dart';
import 'package:ssr_server/ssr_server.dart';

class ${className}Page extends SsrPageBase {
  ${className}Page() : super(
    path: '/$fileName',
    title: '$className',
    description: '$className page',
  );

  @override
  Future<String> render(Map<String, dynamic> data) async {
    final templateEngine = TemplateEngine('templates');
    await templateEngine.init();
    return templateEngine.render('pages/$fileName.html', data);
  }

  @override
  Future<Map<String, dynamic>> getInitialData() async {
    return {};
  }
}
''';
    await File('lib/pages/${fileName}_page.dart').writeAsString(pageContent);

    // Create template
    final templateContent = '''
{% extends "base.html" %}

{% block title %}$className{% endblock %}
{% block description %}$className page{% endblock %}

{% block content %}
<h1>$className</h1>
<p style="margin-top: 1rem;">This is the $className page.</p>
{% endblock %}
''';
    await File('templates/pages/$fileName.html').writeAsString(templateContent);

    print('✓ Generated page: lib/pages/${fileName}_page.dart');
    print('✓ Generated template: templates/pages/$fileName.html');
    print('');
    print('Don\'t forget to register the page in bin/server.dart:');
    print('  final pages = [');
    print('    HomePage(),');
    print('    ${className}Page(), // <-- Add this line');
    print('  ];');
  }

  Future<void> _generateComponent(ArgResults results) async {
    if (results.rest.isEmpty) {
      stderr.writeln('Error: Component name is required');
      stderr.writeln('Usage: ssr generate component <name>');
      exit(1);
    }

    final name = results.rest.first;
    final className = _toPascalCase(name);
    final fileName = _toSnakeCase(name);

    final content = '''
import 'package:angulardart/angulardart.dart';

@Component(
  selector: '$fileName',
  template: '''
    <div class="$fileName">
      <ng-content></ng-content>
    </div>
  ''',
  styles: [
    '''
    .$fileName {
      padding: 1rem;
    }
    '''
  ],
)
class ${className}Component {
  ${className}Component();
}
''';

    await File('lib/components/${fileName}_component.dart').writeAsString(content);
    print('✓ Generated component: lib/components/${fileName}_component.dart');
  }

  Future<void> _generateService(ArgResults results) async {
    if (results.rest.isEmpty) {
      stderr.writeln('Error: Service name is required');
      stderr.writeln('Usage: ssr generate service <name>');
      exit(1);
    }

    final name = results.rest.first;
    final className = _toPascalCase(name);
    final fileName = _toSnakeCase(name);

    final content = '''
import 'package:angulardart/angulardart.dart';

@Injectable()
class ${className}Service {
  ${className}Service();

  // Add your service methods here
}
''';

    await File('lib/services/${fileName}_service.dart').writeAsString(content);
    print('✓ Generated service: lib/services/${fileName}_service.dart');
  }

  String _toPascalCase(String s) {
    return s.split('-').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join('');
  }

  String _toSnakeCase(String s) {
    return s.replaceAll('-', '_');
  }
}
