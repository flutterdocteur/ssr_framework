# API Reference - ssr_hydration

Hydratation automatique pour le framework.

## Classes

### `HydrationEngine`

Moteur de sérialisation/désérialisation pour le transfert de données.

```dart
class HydrationEngine {
  String serialize(Map<String, dynamic> data);
  Map<String, dynamic> deserialize(String json);
  String generateScriptTag(Map<String, dynamic> data);
}
```

**Méthodes :**

- `serialize(data)` : Sérialise les données en JSON
- `deserialize(json)` : Désérialise le JSON en Map
- `generateScriptTag(data)` : Génère une balise `<script>` pour l'hydratation

**Exemple :**

```dart
final engine = HydrationEngine();

// Sérialiser
final json = engine.serialize({'name': 'Alice', 'age': 30});

// Désérialiser
final data = engine.deserialize(json);

// Générer le script tag
final script = engine.generateScriptTag({'profiles': [...]});
// <script id="initial-data" type="application/json">{"profiles":[...]}</script>
```

### `DataTransfer`

Utilitaires pour le transfert de données serveur → client.

```dart
class DataTransfer {
  static String toScriptTag(Map<String, dynamic> data);
}
```

**Méthodes :**

- `toScriptTag(data)` : Convertit les données en balise script

**Exemple :**

```dart
final script = DataTransfer.toScriptTag({
  'user': {'id': 1, 'name': 'Alice'},
});
```

## Flux d'hydratation

```
┌─────────────────────────────────────────────────────────────┐
│ 1. Serveur                                                   │
├─────────────────────────────────────────────────────────────┤
│ Page rendue avec données                                     │
│ ↓                                                            │
│ HydrationEngine.generateScriptTag(data)                      │
│ ↓                                                            │
│ <script id="initial-data" type="application/json">...</script>│
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│ 2. Client                                                    │
├─────────────────────────────────────────────────────────────┤
│ HydrationService.hydrate()                                   │
│ ↓                                                            │
│ Lit <script id="initial-data">                               │
│ ↓                                                            │
│ jsonDecode() → Map<String, dynamic>                          │
│ ↓                                                            │
│ Store dispatch(setData)                                      │
└─────────────────────────────────────────────────────────────┘
```

## Utilisation côté serveur

```dart
import 'package:ssr_hydration/ssr_hydration.dart';

class HomePage extends SsrPageBase {
  @override
  Future<String> render(Map<String, dynamic> data) async {
    final engine = TemplateEngine('templates');
    await engine.init();
    
    final initialData = await getInitialData();
    final hydrationScript = HydrationEngine().generateScriptTag(initialData);
    
    return engine.render('pages/home.html', {
      ...initialData,
      'hydration_script': hydrationScript,
    });
  }
  
  @override
  Future<Map<String, dynamic>> getInitialData() async {
    return {
      'profiles': await _fetchProfiles(),
    };
  }
}
```

## Utilisation côté client

```dart
import 'package:ssr_hydration/ssr_hydration.dart';

@Component(
  selector: 'app-root',
  template: '<main></main>',
)
class AppComponent implements OnInit {
  final HydrationEngine _engine = HydrationEngine();
  
  @override
  void ngOnInit() {
    final data = _engine.hydrate();
    if (data != null) {
      // Initialiser le state avec les données hydratées
      _store.dispatch(AppAction(AppActionType.setProfiles, data['profiles']));
    }
  }
}
```

## Template HTML

```html
<!DOCTYPE html>
<html>
<head>
  <title>{{ title }}</title>
</head>
<body>
  <app-root>
    <!-- Contenu SSR -->
  </app-root>
  
  {{ hydration_script }}
  <script defer src="/static/main.dart.js"></script>
</body>
</html>
```
