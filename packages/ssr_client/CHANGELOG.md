# Changelog

All notable changes to SSR Framework will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.3] - 2025-07-31

### Changed
- ApiService now creates its own BrowserClient internally
- Removed Client injection requirement

## [0.1.2] - 2025-07-31

### Changed
- Removed AngularDart dependency from services
- Services are now plain Dart classes, injection handled by the application

## [0.1.1] - 2025-07-31

### Fixed
- Add missing `matches` and `extractParams` implementations in `NavigationService`

## [0.1.0] - 2024-01-26

### Added
- Initial release
- **ssr_core**: Core interfaces and types
  - `SsrApp`, `SsrPage`, `SsrConfig`
  - `SsrRouter`, `SsrRoute`
  - `SsrState` for state management
  
- **ssr_server**: Server-side rendering engine
  - HTTP server with Alfred
  - Template engine with Jinja
  - Static file serving
  - SEO routes (sitemap.xml, robots.txt)
  - PWA support (manifest.json)
  
- **ssr_client**: Client-side hydration
  - `HydrationService` for data transfer
  - `NavigationService` for client-side routing
  - `ApiService` for HTTP requests
  - `MetaService` for dynamic meta tags
  
- **ssr_router**: File-based routing
  - Automatic route discovery
  - Dynamic routes with parameters
  - Route registry
  
- **ssr_hydration**: Automatic hydration
  - Server-to-client data transfer
  - JSON serialization/deserialization
  
- **ssr_seo**: SEO utilities
  - Sitemap generation
  - Robots.txt generation
  - Meta tags management
  
- **ssr_pwa**: PWA utilities
  - Manifest generation
  - Service worker generation
  - Offline support
  
- **ssr_cli**: Command-line interface
  - `ssr create` - Create new projects
  - `ssr generate` - Generate pages, components, services
  - `ssr build` - Build for production
  - `ssr serve` - Start development server
  
- **ssr_example**: Example application
  - Home page
  - Profile page
  - About page
  - Full SSR + hydration demo

### Features
- Server-Side Rendering (SSR)
- Automatic hydration
- File-based routing
- Code splitting with deferred imports
- Prefetching with IntersectionObserver
- Optimistic updates
- Error boundaries
- Loading states
- Page transitions
- SEO optimization (meta tags, sitemap, robots)
- PWA support (service worker, manifest, offline)
- SQLite database integration
- State management (Redux-like)
- API client
- Dynamic meta tags

### Documentation
- Quick start guide
- Installation guide
- Deployment guide
- Configuration guide
- Best practices
- Troubleshooting
- FAQ
- API reference for all packages
- Example applications (blog, portfolio)

[0.1.0]: https://github.com/flutterdocteur/ssr_framework/releases/tag/v0.1.0
