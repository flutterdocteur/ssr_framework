# ssr_pwa

PWA utilities for SSR Framework.

## Overview

`ssr_pwa` provides Progressive Web App (PWA) support including manifest generation and service worker generation.

## Installation

```yaml
dependencies:
  ssr_pwa: ^0.1.0
```

## Usage

```dart
import 'package:ssr_pwa/ssr_pwa.dart';

// Generate manifest
final manifest = ManifestGenerator.generate(
  name: 'My App',
  shortName: 'App',
  description: 'My awesome app',
  startUrl: '/',
  themeColor: '#2c3e50',
  backgroundColor: '#ffffff',
  icons: [
    {
      'src': '/static/icons/icon-192.png',
      'sizes': '192x192',
      'type': 'image/png',
    },
  ],
);

// Generate service worker
final sw = ServiceWorkerGenerator.generate(
  cacheName: 'my-app-v1',
  staticAssets: [
    '/',
    '/static/main.dart.js',
    '/manifest.json',
  ],
);
```

## API

### Classes

- **`ManifestGenerator`** - Manifest.json generation
- **`ServiceWorkerGenerator`** - Service worker JavaScript generation

## Features

- Manifest.json generation
- Service worker generation
- Cache strategies (network-first, cache-first)
- Offline support
- Installable PWA

## Documentation

Full API documentation: [docs/api/ssr_pwa.md](../../docs/api/ssr_pwa.md)

## License

MIT
