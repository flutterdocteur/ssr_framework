# ssr_cli

Command-line interface for SSR Framework.

## Overview

`ssr_cli` provides command-line tools for creating and managing SSR Framework projects.

## Installation

```bash
# From the framework directory
cd packages/ssr_cli
dart pub global activate --source path .
```

## Usage

```bash
# Create a new project
ssr create my-app

# Generate a page
ssr generate page contact

# Generate a component
ssr generate component user-card

# Generate a service
ssr generate service auth

# Build for production
ssr build --release

# Start development server
ssr serve
```

## Commands

### `ssr create <project-name>`

Create a new SSR project with the following structure:
- `bin/server.dart` - Server entry point
- `lib/pages/` - SSR pages
- `lib/components/` - AngularDart components
- `lib/services/` - Services
- `templates/` - Jinja templates
- `public/` - Static files
- `web/` - Client entry point

### `ssr generate <type> <name>`

Generate code for:
- **page** - Creates page class and template
- **component** - Creates AngularDart component
- **service** - Creates service class

### `ssr build`

Build the project for production:
- Runs `build_runner build`
- Copies generated files to `public/`
- Optimizes JavaScript bundles

### `ssr serve`

Start the development server:
- Default port: 3000
- Custom port: `ssr serve --port 8080`

## API

### Utilities

- **`FileUtils`** - File manipulation utilities
- **`TemplateUtils`** - String manipulation utilities

## Documentation

Full API documentation: [docs/api/ssr_cli.md](../../docs/api/ssr_cli.md)

## License

MIT
