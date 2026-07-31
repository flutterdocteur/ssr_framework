import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;

class CreateCommand {
  ArgParser get parser => ArgParser()
    ..addOption('template',
        abbr: 't',
        defaultsTo: 'basic',
        allowed: ['basic', 'full'],
        help: 'Project template to use')
    ..addFlag('force',
        abbr: 'f',
        negatable: false,
        help: 'Force creation even if directory exists');

  Future<void> run(ArgResults results) async {
    if (results.rest.isEmpty) {
      stderr.writeln('Error: Project name is required');
      stderr.writeln('Usage: ssr create <project-name>');
      exit(1);
    }

    final projectName = results.rest.first.replaceAll('-', '_');
    final template = results['template'] as String;
    final force = results['force'] as bool;

    final projectDir = Directory(projectName);

    if (projectDir.existsSync() && !force) {
      stderr.writeln('Error: Directory "$projectName" already exists');
      stderr.writeln('Use --force to overwrite');
      exit(1);
    }

    print('Creating SSR project "$projectName" with template "$template"...');

    await _createProjectStructure(projectName, template);

    print('');
    print('✓ Project created successfully!');
    print('');
    print('Next steps:');
    print('  cd $projectName');
    print('  dart pub get');
    print('  dart run build_runner build');
    print('  dart run bin/server.dart');
  }

  Future<void> _createProjectStructure(String name, String template) async {
    final projectDir = Directory(name);
    await projectDir.create(recursive: true);

    // Create directory structure
    final dirs = [
      'bin',
      'lib/pages',
      'lib/components',
      'lib/services',
      'web',
      'public',
      'templates/pages',
      'templates/components',
      'test',
    ];

    for (final dir in dirs) {
      await Directory(path.join(name, dir)).create(recursive: true);
    }

    // Create pubspec.yaml
    await _createPubspec(name);

    // Create main server file
    await _createServerFile(name);

    // Create main client file
    await _createClientFile(name);

    // Create base template
    await _createBaseTemplate(name);

    // Create home page
    await _createHomePage(name);

    // Create about page
    await _createAboutPage(name);

    // Create index.html
    await _createIndexHtml(name);

    // Create README
    await _createReadme(name);

    // Create .gitignore
    await _createGitignore(name);
  }

  Future<void> _createPubspec(String name) async {
    final content = '''
name: $name
description: A new SSR Framework project
version: 0.1.0
publish_to: none

environment:
  sdk: ^3.12.2

dependencies:
  ssr_core: ^0.1.0
  ssr_server: ^0.1.0
  ssr_client: ^0.1.1
  alfred: ^1.1.3
  jinja: ^0.6.7
  sqlite3: ^2.4.0
  http: ^1.2.0
  angulardart: ^8.0.6

dev_dependencies:
  build_runner: ^2.4.0
  build_web_compilers: ^4.0.0
  lints: ^4.0.0
  test: ^1.25.0
  angulardart_test: ^5.0.2
''';
    await File('$name/pubspec.yaml').writeAsString(content);
  }

  Future<void> _createServerFile(String name) async {
    final content = '''
import 'package:ssr_core/ssr_core.dart';
import 'package:ssr_server/ssr_server.dart';
import 'pages/home_page.dart';
import 'pages/about_page.dart';

void main() async {
  final config = SsrConfig(
    name: '${_capitalize(name)}',
    baseUrl: 'http://localhost:3000',
    port: 3000,
    devMode: true,
    staticDir: 'public',
    templatesDir: 'templates',
    enablePwa: true,
    enableSeo: true,
  );

  final pages = [
    HomePage(),
    AboutPage(),
  ];

  final server = SsrServer(config: config, pages: pages);
  await server.start();
}
''';
    await File('$name/bin/server.dart').writeAsString(content);
  }

  Future<void> _createClientFile(String name) async {
    final content = '''
import 'package:angulardart/angulardart.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart';
import 'package:ssr_client/ssr_client.dart';
import 'app_component.template.dart' as ng;

import 'main.template.dart' as ngMain;

void main() {
  runApp(
    ng.AppComponentNgFactory,
    createInjector: ngMain.appInjector\$Injector,
  );
}

@GenerateInjector([
  ClassProvider(NavigationService),
  ClassProvider(ApiService),
  ClassProvider(MetaService),
  ClassProvider(Client, useClass: BrowserClient),
])
final appInjector = ngMain.appInjector\$Injector;
''';
    await File('$name/web/main.dart').writeAsString(content);
  }

  Future<void> _createBaseTemplate(String name) async {
    final content = '''
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <base href="/">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title id="meta-title">{% block title %}${_capitalize(name)}{% endblock %}</title>
  <meta id="meta-description" name="description" content="{% block description %}A new SSR Framework project{% endblock %}">
  <link rel="manifest" href="/manifest.json">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; line-height: 1.6; color: #333; }
    .container { max-width: 1200px; margin: 0 auto; padding: 0 20px; }
    nav { background: #2c3e50; color: white; padding: 1rem 0; }
    nav .container { display: flex; justify-content: space-between; align-items: center; }
    nav a { color: white; text-decoration: none; margin-left: 1rem; }
    nav a:hover { text-decoration: underline; }
    main { padding: 2rem 0; min-height: calc(100vh - 140px); }
    footer { background: #34495e; color: white; padding: 1rem 0; text-align: center; }
    .btn { display: inline-block; padding: 0.5rem 1rem; background: #3498db; color: white; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; }
    .btn:hover { background: #2980b9; }
  </style>
  {% block head %}{% endblock %}
</head>
<body>
  <app-root>
    <nav>
      <div class="container">
        <strong>${_capitalize(name)}</strong>
        <div>
          <a href="/">Accueil</a>
          <a href="/about">À propos</a>
        </div>
      </div>
    </nav>

    <main>
      <div class="container">
        {% block content %}{% endblock %}
      </div>
    </main>

    <footer>
      <div class="container">
        <p>Propulsé par SSR Framework</p>
      </div>
    </footer>
  </app-root>

  {% if initial_data %}
  <script id="initial-data" type="application/json">{{ initial_data }}</script>
  {% endif %}
  <script defer src="/static/main.dart.js"></script>
</body>
</html>
''';
    await File('$name/templates/base.html').writeAsString(content);
  }

  Future<void> _createHomePage(String name) async {
    // Create page class
    final pageContent = '''
import 'package:ssr_core/ssr_core.dart';
import 'package:ssr_server/ssr_server.dart';

class HomePage extends SsrPageBase {
  HomePage() : super(
    path: '/',
    title: 'Accueil - ${_capitalize(name)}',
    description: 'Page d\\'accueil de ${_capitalize(name)}',
  );

  @override
  Future<String> render(Map<String, dynamic> data) async {
    final templateEngine = TemplateEngine('templates');
    await templateEngine.init();
    return templateEngine.render('pages/home.html', data);
  }

  @override
  Future<Map<String, dynamic>> getInitialData() async {
    return {
      'message': 'Bienvenue sur ${_capitalize(name)}!',
    };
  }
}
''';
    await File('$name/lib/pages/home_page.dart').writeAsString(pageContent);

    // Create template
    final templateContent = '''
{% extends "base.html" %}

{% block title %}Accueil - ${_capitalize(name)}{% endblock %}
{% block description %}Page d\\'accueil de ${_capitalize(name)}{% endblock %}

{% block content %}
<h1>{{ message }}</h1>
<p style="margin-top: 1rem;">Ce projet a été créé avec SSR Framework.</p>
<div style="margin-top: 2rem;">
  <a href="/about" class="btn">En savoir plus</a>
</div>
{% endblock %}
''';
    await File('$name/templates/pages/home.html').writeAsString(templateContent);
  }

  Future<void> _createAboutPage(String name) async {
    // Create page class
    final pageContent = '''
import 'package:ssr_core/ssr_core.dart';
import 'package:ssr_server/ssr_server.dart';

class AboutPage extends SsrPageBase {
  AboutPage() : super(
    path: '/about',
    title: 'À propos - ${_capitalize(name)}',
    description: 'À propos de ${_capitalize(name)}',
  );

  @override
  Future<String> render(Map<String, dynamic> data) async {
    final templateEngine = TemplateEngine('templates');
    await templateEngine.init();
    return templateEngine.render('pages/about.html', data);
  }
}
''';
    await File('$name/lib/pages/about_page.dart').writeAsString(pageContent);

    // Create template
    final templateContent = '''
{% extends "base.html" %}

{% block title %}À propos - ${_capitalize(name)}{% endblock %}
{% block description %}À propos de ${_capitalize(name)}{% endblock %}

{% block content %}
<h1>À propos</h1>
<p style="margin-top: 1rem;">Cette application a été créée avec SSR Framework.</p>
<p style="margin-top: 1rem;">SSR Framework est un framework Dart moderne inspiré de Next.js.</p>
<div style="margin-top: 2rem;">
  <a href="/" class="btn">Retour à l'accueil</a>
</div>
{% endblock %}
''';
    await File('$name/templates/pages/about.html').writeAsString(templateContent);
  }

  Future<void> _createIndexHtml(String name) async {
    final content = '''
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <base href="/">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${_capitalize(name)}</title>
</head>
<body>
  <app-root>Chargement...</app-root>
  <script defer src="main.dart.js"></script>
</body>
</html>
''';
    await File('$name/web/index.html').writeAsString(content);
  }

  Future<void> _createReadme(String name) async {
    final content = '''
# ${_capitalize(name)}

Un projet créé avec SSR Framework.

## Démarrage rapide

\`\`\`bash
# Installer les dépendances
dart pub get

# Build le client
dart run build_runner build --release

# Démarrer le serveur
dart run bin/server.dart
\`\`\`

## Structure du projet

\`\`\`
$name/
├── bin/              # Fichiers serveur
├── lib/              # Code Dart
│   ├── pages/        # Pages SSR
│   ├── components/   # Composants AngularDart
│   └── services/     # Services
├── web/              # Fichiers client
├── public/           # Fichiers statiques
├── templates/        # Templates Jinja
└── test/             # Tests
\`\`\`

## Développement

Pour développer avec rechargement automatique :

\`\`\`bash
dart run build_runner watch
\`\`\`

## Production

Pour construire pour la production :

\`\`\`bash
dart run build_runner build --release
\`\`\`

## Licence

MIT
''';
    await File('$name/README.md').writeAsString(content);
  }

  Future<void> _createGitignore(String name) async {
    final content = '''
# Dart/Flutter
.dart_tool/
.packages
build/
pubspec.lock

# IDE
.idea/
.vscode/
*.iml

# OS
.DS_Store
Thumbs.db

# Build outputs
*.js.map
*.js.tar.gz
*.part.js

# Logs
*.log
logs/
''';
    await File('$name/.gitignore').writeAsString(content);
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}
