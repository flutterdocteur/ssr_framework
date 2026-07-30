# ssr_router

File-based routing for SSR Framework.

## Overview

`ssr_router` provides automatic route discovery based on file structure, similar to Next.js's file-based routing.

## Installation

```yaml
dependencies:
  ssr_router: ^0.1.0
```

## Usage

```dart
import 'package:ssr_router/ssr_router.dart';

final router = FileRouter(pagesDir: 'lib/pages');
final routes = await router.discoverRoutes();

for (final route in routes) {
  print('${route.path} -> ${route.handler}');
}
```

## File Structure Convention

```
lib/pages/
├── home_page.dart              → /
├── about_page.dart             → /about
├── profile/
│   └── [id]_page.dart          → /profile/:id
└── blog/
    └── [slug]_page.dart        → /blog/:slug
```

## API

### Classes

- **`FileRouter`** - Automatic route discovery
- **`RouteRegistry`** - Route registry with matching

## Features

- Automatic route discovery from file structure
- Dynamic routes with parameters
- Nested routes
- Route matching and parameter extraction

## Documentation

Full API documentation: [docs/api/ssr_router.md](../../docs/api/ssr_router.md)

## License

MIT
