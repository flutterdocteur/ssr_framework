# ssr_client

Client-side hydration and routing for SSR Framework.

## Overview

`ssr_client` provides client-side capabilities including hydration, routing, API client, and meta tag management. It's built on AngularDart.

## Installation

```yaml
dependencies:
  ssr_client: ^0.1.0
```

## Usage

```dart
import 'package:angulardart/angulardart.dart';
import 'package:ssr_client/ssr_client.dart';

@Component(
  selector: 'app-root',
  template: '<main></main>',
)
class AppComponent implements OnInit {
  final NavigationService _nav;
  final MetaService _meta;
  
  AppComponent(this._nav, this._meta);
  
  @override
  void ngOnInit() {
    _nav.onRouteChange.listen((path) {
      _meta.updateMeta(title: 'Page: $path');
    });
  }
}
```

## API

### Services

- **`HydrationService`** - Hydrate server data on client
- **`NavigationService`** - Client-side routing
- **`ApiService`** - HTTP client for API calls
- **`MetaService`** - Dynamic meta tag management

## Features

- Automatic hydration from server data
- Client-side routing with pushState
- API client with error handling
- Dynamic meta tags for SEO
- Prefetching support

## Documentation

Full API documentation: [docs/api/ssr_client.md](../../docs/api/ssr_client.md)

## License

MIT
