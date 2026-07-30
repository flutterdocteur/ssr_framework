# ssr_hydration

Automatic hydration for SSR Framework.

## Overview

`ssr_hydration` handles the transfer of data from server to client, enabling automatic hydration of server-rendered pages.

## Installation

```yaml
dependencies:
  ssr_hydration: ^0.1.0
```

## Usage

### Server-side

```dart
import 'package:ssr_hydration/ssr_hydration.dart';

final engine = HydrationEngine();
final data = {'profiles': [...]};
final script = engine.generateScriptTag(data);
// <script id="initial-data" type="application/json">{"profiles":[...]}</script>
```

### Client-side

```dart
import 'package:ssr_hydration/ssr_hydration.dart';

final engine = HydrationEngine();
final data = engine.hydrate();
// Returns the data from the script tag
```

## API

### Classes

- **`HydrationEngine`** - Serialization/deserialization engine
- **`DataTransfer`** - Data transfer utilities

## Features

- JSON serialization/deserialization
- Script tag generation
- Automatic hydration on client
- Type-safe data transfer

## Documentation

Full API documentation: [docs/api/ssr_hydration.md](../../docs/api/ssr_hydration.md)

## License

MIT
