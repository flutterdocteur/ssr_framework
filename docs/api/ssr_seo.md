# API Reference - ssr_seo

SEO utilities pour le framework.

## Classes

### `SeoGenerator`

Générateur de fichiers SEO (sitemap.xml, robots.txt).

```dart
class SeoGenerator {
  final String baseUrl;
  final List<SsrPage> pages;
  
  SeoGenerator(this.baseUrl, this.pages);
  
  String generateSitemap();
  String generateRobotsTxt();
}
```

**Méthodes :**

- `generateSitemap()` : Génère le contenu XML du sitemap
- `generateRobotsTxt()` : Génère le contenu de robots.txt

**Exemple :**

```dart
final generator = SeoGenerator('https://myapp.com', pages);

// Sitemap
final sitemap = generator.generateSitemap();
// <?xml version="1.0" encoding="UTF-8"?>
// <urlset xmlns="...">
//   <url>
//     <loc>https://myapp.com/</loc>
//     <priority>1.0</priority>
//   </url>
//   ...
// </urlset>

// Robots.txt
final robots = generator.generateRobotsTxt();
// User-agent: *
// Allow: /
// Sitemap: https://myapp.com/sitemap.xml
```

### `MetaTags`

Générateur de balises meta HTML.

```dart
class MetaTags {
  static String generate({
    required String title,
    String? description,
    String? canonical,
    Map<String, String>? openGraph,
    Map<String, String>? twitter,
  });
}
```

**Paramètres :**

- `title` : Titre de la page (requis)
- `description` : Description meta
- `canonical` : URL canonique
- `openGraph` : Tags Open Graph (og:title, og:description, etc.)
- `twitter` : Tags Twitter Card (twitter:title, etc.)

**Exemple :**

```dart
final meta = MetaTags.generate(
  title: 'Accueil - Mon App',
  description: 'Bienvenue sur mon application',
  canonical: 'https://myapp.com/',
  openGraph: {
    'title': 'Mon App',
    'description': 'Application incroyable',
    'image': 'https://myapp.com/og-image.jpg',
    'url': 'https://myapp.com/',
  },
  twitter: {
    'card': 'summary_large_image',
    'title': 'Mon App',
    'description': 'Application incroyable',
  },
);

// Génère :
// <title>Accueil - Mon App</title>
// <meta name="description" content="Bienvenue sur mon application">
// <link rel="canonical" href="https://myapp.com/">
// <meta property="og:title" content="Mon App">
// <meta property="og:description" content="Application incroyable">
// <meta property="og:image" content="https://myapp.com/og-image.jpg">
// <meta name="twitter:card" content="summary_large_image">
// ...
```

## Priorités du sitemap

| Page | Priorité |
|------|----------|
| `/` (accueil) | 1.0 |
| `/about` | 0.5 |
| Autres pages | 0.8 |

## Utilisation avec SsrServer

Le serveur intègre automatiquement le SEO si `enableSeo: true` :

```dart
final config = SsrConfig(
  name: 'My App',
  enableSeo: true,  // Active les routes SEO
);

final server = SsrServer(config: config, pages: pages);
```

Routes automatiques :
- `GET /sitemap.xml` → Sitemap XML
- `GET /robots.txt` → Robots.txt

## Meta tags dynamiques côté client

```dart
import 'package:ssr_seo/ssr_seo.dart';

// Dans un composant AngularDart
void updatePageMeta() {
  final meta = MetaTags.generate(
    title: 'Profil - Mon App',
    description: 'Voir le profil utilisateur',
    canonical: 'https://myapp.com/profile/1',
  );
  
  // Injecter dans le DOM
  document.head!.appendHtml(meta);
}
```

## Bonnes pratiques

1. **Titres uniques** : Chaque page doit avoir un titre unique
2. **Descriptions** : 150-160 caractères max
3. **Open Graph** : Image 1200x630px recommandée
4. **Canonical** : Toujours définir l'URL canonique
5. **Sitemap** : Mettre à jour lors de l'ajout de pages
