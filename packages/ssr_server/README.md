# ssr_server

Server-side rendering engine for SSR Framework.

## Overview

`ssr_server` provides the HTTP server, template engine, and SSR capabilities. It uses Alfred for the HTTP server and Jinja for templating.

## Installation

```yaml
dependencies:
  ssr_server: ^0.1.0
```

## Usage

```dart
import 'package:ssr_core/ssr_core.dart';
import 'package:ssr_server/ssr_server.dart';

void main() async {
  final config = SsrConfig(
    name: 'My App',
    port: 3000,
    templatesDir: 'templates',
    staticDir: 'public',
  );

  final pages = [
    HomePage(),
    AboutPage(),
  ];

  final server = SsrServer(config: config, pages: pages);
  await server.start();
}
```

## API

### Classes

- **`SsrServer`** - Main HTTP server
- **`TemplateEngine`** - Jinja template engine
- **`StaticHandler`** - Static file serving
- **`SeoHandler`** - SEO file generation (sitemap.xml, robots.txt)

## Features

- HTTP server with Alfred
- Server-side rendering
- Jinja template engine
- Static file serving
- Automatic SEO routes
- PWA support
- Middleware system

## Documentation

Full API documentation: [docs/api/ssr_server.md](../../docs/api/ssr_server.md)

## License

MIT
