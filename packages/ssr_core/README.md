# ssr_core

Core interfaces and types for SSR Framework.

## Overview

`ssr_core` provides the fundamental interfaces and types that define the SSR Framework architecture. All other packages depend on this package.

## Installation

```yaml
dependencies:
  ssr_core: ^0.1.0
```

## Usage

```dart
import 'package:ssr_core/ssr_core.dart';

// Define a page
class HomePage extends SsrPageBase {
  HomePage() : super(
    path: '/',
    title: 'Home',
    description: 'Welcome to my app',
  );

  @override
  Future<String> render(Map<String, dynamic> data) async {
    return '<html><body>${data['message']}</body></html>';
  }

  @override
  Future<Map<String, dynamic>> getInitialData() async {
    return {'message': 'Hello, World!'};
  }
}

// Configure the app
final config = SsrConfig(
  name: 'My App',
  port: 3000,
  enablePwa: true,
  enableSeo: true,
);
```

## API

### Classes

- **`SsrApp`** - Application interface
- **`SsrPage`** - Page interface
- **`SsrPageBase`** - Base page implementation
- **`SsrDynamicPage`** - Dynamic page with route parameters
- **`SsrConfig`** - Configuration class
- **`SsrRouter`** - Router interface
- **`SsrRoute`** - Route definition
- **`SsrState`** - State management interface

## Documentation

Full API documentation: [docs/api/ssr_core.md](../../docs/api/ssr_core.md)

## License

MIT
