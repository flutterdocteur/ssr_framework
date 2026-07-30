# ssr_example

Example application demonstrating SSR Framework features.

## Overview

This is a complete example application built with SSR Framework, showcasing all major features including SSR, hydration, routing, SEO, and PWA support.

## Features

- ✅ Server-Side Rendering
- ✅ Automatic Hydration
- ✅ Client-side Routing
- ✅ Code Splitting
- ✅ SEO Optimization
- ✅ PWA Support
- ✅ SQLite Database
- ✅ State Management
- ✅ Error Boundaries
- ✅ Loading States
- ✅ Prefetching

## Pages

- **Home** (`/`) - List of profiles
- **Profile** (`/profile/:id`) - Profile details
- **About** (`/about`) - About page

## Running the Example

### 1. Install dependencies

```bash
dart pub get
```

### 2. Build the client

```bash
ssr build
# or
dart run build_runner build --delete-conflicting-outputs
```

### 3. Start the server

```bash
ssr serve
# or
dart run bin/server.dart
```

### 4. Open in browser

Visit [http://localhost:3000](http://localhost:3000)

## Project Structure

```
ssr_example/
├── bin/
│   └── server.dart              # Server entry point
├── lib/
│   ├── pages/                   # SSR pages
│   │   ├── home_page.dart
│   │   ├── profile_page.dart
│   │   └── about_page.dart
│   ├── components/              # AngularDart components
│   └── services/                # Services
├── web/
│   ├── index.html               # Client HTML
│   └── main.dart                # Client entry point
├── public/                      # Static files
│   ├── main.dart.js             # Compiled JS
│   ├── manifest.json            # PWA manifest
│   └── sw.js                    # Service worker
├── templates/                   # Jinja templates
│   ├── base.html
│   └── pages/
│       ├── home.html
│       ├── profile.html
│       └── about.html
└── test/                        # Tests
```

## Key Concepts

### SSR Pages

```dart
class HomePage extends SsrPageBase {
  HomePage() : super(
    path: '/',
    title: 'Home',
    description: 'Welcome to SSR Example',
  );

  @override
  Future<Map<String, dynamic>> getInitialData() async {
    return {'profiles': await _fetchProfiles()};
  }
}
```

### Client-side Routing

```dart
final nav = NavigationService();
nav.onRouteChange.listen((path) {
  // Load appropriate component
});
```

### State Management

```dart
final store = AppStore();
store.dispatch(AppAction(AppActionType.setProfiles, profiles));
```

## Testing

```bash
# Run all tests
dart test

# Run with coverage
dart test --coverage=coverage
```

## Building for Production

```bash
ssr build --release
```

## Deployment

See the [Deployment Guide](../../docs/guides/deployment.md) for deployment options.

## Documentation

- [Quick Start](../../docs/guides/quickstart.md)
- [API Reference](../../docs/api/README.md)
- [Best Practices](../../docs/guides/best-practices.md)

## License

MIT
