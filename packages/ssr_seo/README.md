# ssr_seo

SEO utilities for SSR Framework.

## Overview

`ssr_seo` provides SEO optimization tools including sitemap generation, robots.txt, and meta tag management.

## Installation

```yaml
dependencies:
  ssr_seo: ^0.1.0
```

## Usage

```dart
import 'package:ssr_seo/ssr_seo.dart';

// Generate sitemap
final generator = SeoGenerator('https://myapp.com', pages);
final sitemap = generator.generateSitemap();
final robots = generator.generateRobotsTxt();

// Generate meta tags
final meta = MetaTags.generate(
  title: 'My Page',
  description: 'Page description',
  canonical: 'https://myapp.com/page',
  openGraph: {
    'title': 'OG Title',
    'description': 'OG Description',
    'image': 'https://myapp.com/image.jpg',
  },
);
```

## API

### Classes

- **`SeoGenerator`** - Sitemap and robots.txt generation
- **`MetaTags`** - HTML meta tag generation

## Features

- Automatic sitemap.xml generation
- Automatic robots.txt generation
- Dynamic meta tags
- Open Graph support
- Twitter Card support
- Canonical URLs

## Documentation

Full API documentation: [docs/api/ssr_seo.md](../../docs/api/ssr_seo.md)

## License

MIT
