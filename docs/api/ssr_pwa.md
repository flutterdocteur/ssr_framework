# API Reference - ssr_pwa

PWA utilities pour le framework.

## Classes

### `ManifestGenerator`

Générateur de manifest.json pour PWA.

```dart
class ManifestGenerator {
  static String generate({
    required String name,
    required String shortName,
    required String description,
    required String startUrl,
    required String themeColor,
    required String backgroundColor,
    List<Map<String, dynamic>>? icons,
  });
}
```

**Paramètres :**

- `name` : Nom complet de l'application
- `shortName` : Nom court (max 12 caractères)
- `description` : Description de l'application
- `startUrl` : URL de démarrage (généralement `/`)
- `themeColor` : Couleur du thème (ex: `#2c3e50`)
- `backgroundColor` : Couleur de fond (ex: `#ffffff`)
- `icons` : Liste des icônes (optionnel)

**Exemple :**

```dart
final manifest = ManifestGenerator.generate(
  name: 'Mon Application',
  shortName: 'MonApp',
  description: 'Une application incroyable',
  startUrl: '/',
  themeColor: '#2c3e50',
  backgroundColor: '#ffffff',
  icons: [
    {
      'src': '/static/icons/icon-192.png',
      'sizes': '192x192',
      'type': 'image/png',
    },
    {
      'src': '/static/icons/icon-512.png',
      'sizes': '512x512',
      'type': 'image/png',
    },
  ],
);

// Génère :
// {
//   "name": "Mon Application",
//   "short_name": "MonApp",
//   "description": "Une application incroyable",
//   "start_url": "/",
//   "display": "standalone",
//   "theme_color": "#2c3e50",
//   "background_color": "#ffffff",
//   "icons": [...]
// }
```

### `ServiceWorkerGenerator`

Générateur de service worker JavaScript.

```dart
class ServiceWorkerGenerator {
  static String generate({
    String cacheName = 'ssr-app-v1',
    List<String> staticAssets = const [],
  });
}
```

**Paramètres :**

- `cacheName` : Nom du cache (pour versioning)
- `staticAssets` : Liste des assets à mettre en cache

**Exemple :**

```dart
final sw = ServiceWorkerGenerator.generate(
  cacheName: 'my-app-v1',
  staticAssets: [
    '/',
    '/static/main.dart.js',
    '/static/styles.css',
    '/manifest.json',
  ],
);
```

## Stratégies de cache

### API (Network First)

```javascript
if (url.pathname.startsWith('/api/')) {
  event.respondWith(
    fetch(event.request).then((response) => {
      // Mettre en cache la réponse
      const clone = response.clone();
      caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, clone);
      });
      return response;
    }).catch(() => {
      // Fallback sur le cache
      return caches.match(event.request);
    })
  );
}
```

### Static Assets (Cache First)

```javascript
event.respondWith(
  caches.match(event.request).then((cached) => {
    if (cached) return cached;
    return fetch(event.request).then((response) => {
      // Mettre en cache pour la prochaine fois
      const clone = response.clone();
      caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, clone);
      });
      return response;
    });
  })
);
```

## Cycle de vie du Service Worker

```
┌─────────────────────────────────────────────────────────────┐
│ 1. Installation                                              │
├─────────────────────────────────────────────────────────────┤
│ self.addEventListener('install', (event) => {                │
│   event.waitUntil(                                           │
│     caches.open(CACHE_NAME).then((cache) => {                │
│       return cache.addAll(STATIC_ASSETS);                    │
│     })                                                       │
│   );                                                         │
│   self.skipWaiting(); // Activer immédiatement               │
│ });                                                          │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│ 2. Activation                                                │
├─────────────────────────────────────────────────────────────┤
│ self.addEventListener('activate', (event) => {               │
│   event.waitUntil(                                           │
│     // Supprimer les anciens caches                          │
│     caches.keys().then((cacheNames) => {                     │
│       return Promise.all(                                    │
│         cacheNames                                           │
│           .filter((name) => name !== CACHE_NAME)             │
│           .map((name) => caches.delete(name))                │
│       );                                                     │
│     })                                                       │
│   );                                                         │
│   self.clients.claim(); // Prendre le contrôle               │
│ });                                                          │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│ 3. Fetch (Interception des requêtes)                         │
├─────────────────────────────────────────────────────────────┤
│ self.addEventListener('fetch', (event) => {                  │
│   // Stratégie Network First pour API                        │
│   // Stratégie Cache First pour static                       │
│ });                                                          │
└─────────────────────────────────────────────────────────────┘
```

## Enregistrement du Service Worker

```html
<script>
  if ('serviceWorker' in navigator) {
    navigator.serviceWorker.register('/static/sw.js')
      .then((reg) => {
        console.log('SW registered:', reg.scope);
      })
      .catch((err) => {
        console.log('SW registration failed:', err);
      });
  }
</script>
```

## Mise à jour du Service Worker

Pour forcer une mise à jour :

```javascript
// Dans sw.js
const CACHE_NAME = 'my-app-v2'; // Incrémenter la version

// L'ancien cache sera supprimé à l'activation
```

## Icônes recommandées

| Taille | Utilisation |
|--------|-------------|
| 72x72 | Android petit |
| 96x96 | Android moyen |
| 128x128 | Chrome Web Store |
| 144x144 | Android grand |
| 152x152 | iOS |
| 192x192 | Android (requis) |
| 384x384 | Android haute résolution |
| 512x512 | Splash screen (requis) |

## Utilisation avec SsrServer

```dart
final config = SsrConfig(
  name: 'My App',
  enablePwa: true,  // Active les routes PWA
);

// Route automatique : GET /manifest.json
```

## Test PWA

1. Ouvrir Chrome DevTools
2. Onglet "Application"
3. Vérifier :
   - Manifest installé
   - Service Worker actif
   - Cache rempli
   - HTTPS activé (requis en production)
