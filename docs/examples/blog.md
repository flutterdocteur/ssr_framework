# Exemple : Blog simple

Application de blog avec SSR Framework.

## Structure

```
blog/
├── bin/
│   └── server.dart
├── lib/
│   ├── pages/
│   │   ├── home_page.dart
│   │   ├── post_page.dart
│   │   └── about_page.dart
│   ├── components/
│   │   ├── post_card_component.dart
│   │   └── comment_component.dart
│   └── services/
│       ├── blog_service.dart
│       └── comment_service.dart
├── templates/
│   ├── base.html
│   └── pages/
│       ├── home.html
│       ├── post.html
│       └── about.html
└── public/
    └── styles.css
```

## Code

### bin/server.dart

```dart
import 'package:ssr_core/ssr_core.dart';
import 'package:ssr_server/ssr_server.dart';
import 'pages/home_page.dart';
import 'pages/post_page.dart';
import 'pages/about_page.dart';

void main() async {
  final config = SsrConfig(
    name: 'Mon Blog',
    baseUrl: 'http://localhost:3000',
    port: 3000,
    devMode: true,
  );

  final pages = [
    HomePage(),
    PostPage(),
    AboutPage(),
  ];

  final server = SsrServer(config: config, pages: pages);
  await server.start();
}
```

### lib/pages/home_page.dart

```dart
import 'package:ssr_core/ssr_core.dart';
import 'package:ssr_server/ssr_server.dart';
import '../services/blog_service.dart';

class HomePage extends SsrPageBase {
  HomePage() : super(
    path: '/',
    title: 'Mon Blog',
    description: 'Bienvenue sur mon blog',
  );

  @override
  Future<String> render(Map<String, dynamic> data) async {
    final templateEngine = TemplateEngine('templates');
    await templateEngine.init();
    return templateEngine.render('pages/home.html', data);
  }

  @override
  Future<Map<String, dynamic>> getInitialData() async {
    final blogService = BlogService();
    final posts = await blogService.getPosts();
    return {'posts': posts};
  }
}
```

### lib/pages/post_page.dart

```dart
import 'package:ssr_core/ssr_core.dart';
import 'package:ssr_server/ssr_server.dart';
import '../services/blog_service.dart';

class PostPage extends SsrDynamicPage {
  PostPage() : super(
    path: '/post/:id',
    pattern: '/post/:id',
    title: 'Article',
  );

  @override
  Map<String, String> extractParams(String actualPath) {
    final match = RegExp(r'/post/(\d+)').firstMatch(actualPath);
    if (match != null) {
      return {'id': match.group(1)!};
    }
    return {};
  }

  @override
  Future<String> render(Map<String, dynamic> data) async {
    final templateEngine = TemplateEngine('templates');
    await templateEngine.init();
    return templateEngine.render('pages/post.html', data);
  }

  @override
  Future<Map<String, dynamic>> getInitialData() async {
    // Cette méthode sera appelée avec les paramètres
    return {};
  }
}
```

### lib/services/blog_service.dart

```dart
class BlogService {
  final List<Map<String, dynamic>> _posts = [
    {
      'id': 1,
      'title': 'Premier article',
      'content': 'Contenu du premier article...',
      'author': 'Alice',
      'date': '2024-01-15',
      'tags': ['dart', 'ssr'],
    },
    {
      'id': 2,
      'title': 'Deuxième article',
      'content': 'Contenu du deuxième article...',
      'author': 'Bob',
      'date': '2024-01-20',
      'tags': ['angular', 'web'],
    },
  ];

  Future<List<Map<String, dynamic>>> getPosts() async {
    return _posts;
  }

  Future<Map<String, dynamic>?> getPost(int id) async {
    try {
      return _posts.firstWhere((p) => p['id'] == id);
    } catch (e) {
      return null;
    }
  }
}
```

### templates/pages/home.html

```html
{% extends "base.html" %}

{% block title %}Mon Blog{% endblock %}
{% block description %}Bienvenue sur mon blog{% endblock %}

{% block content %}
<h1>Articles récents</h1>

<div class="posts-grid">
  {% for post in posts %}
  <article class="post-card">
    <h2><a href="/post/{{ post.id }}">{{ post.title }}</a></h2>
    <p class="meta">
      Par {{ post.author }} le {{ post.date }}
    </p>
    <p>{{ post.content[:200] }}...</p>
    <div class="tags">
      {% for tag in post.tags %}
      <span class="tag">{{ tag }}</span>
      {% endfor %}
    </div>
  </article>
  {% endfor %}
</div>
{% endblock %}
```

### templates/pages/post.html

```html
{% extends "base.html" %}

{% block title %}{{ post.title }} - Mon Blog{% endblock %}
{% block description %}{{ post.content[:150] }}{% endblock %}

{% block content %}
<article class="post">
  <header>
    <h1>{{ post.title }}</h1>
    <p class="meta">
      Par {{ post.author }} le {{ post.date }}
    </p>
  </header>

  <div class="content">
    {{ post.content }}
  </div>

  <footer>
    <div class="tags">
      {% for tag in post.tags %}
      <span class="tag">{{ tag }}</span>
      {% endfor %}
    </div>
  </footer>
</article>

<section class="comments">
  <h2>Commentaires</h2>
  <comment-form post-id="{{ post.id }}"></comment-form>
  <comment-list post-id="{{ post.id }}"></comment-list>
</section>
{% endblock %}
```

### public/styles.css

```css
.posts-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 2rem;
}

.post-card {
  border: 1px solid #ddd;
  padding: 1.5rem;
  border-radius: 8px;
}

.post-card h2 {
  margin-bottom: 0.5rem;
}

.post-card h2 a {
  color: #333;
  text-decoration: none;
}

.post-card h2 a:hover {
  color: #0066cc;
}

.meta {
  color: #666;
  font-size: 0.9rem;
  margin-bottom: 1rem;
}

.tags {
  display: flex;
  gap: 0.5rem;
  margin-top: 1rem;
}

.tag {
  background: #f0f0f0;
  padding: 0.25rem 0.75rem;
  border-radius: 12px;
  font-size: 0.85rem;
}
```

## Fonctionnalités

- ✅ Liste des articles avec pagination
- ✅ Page d'article détaillée
- ✅ Commentaires (composant interactif)
- ✅ Tags et catégories
- ✅ SEO optimisé (meta tags dynamiques)
- ✅ Prefetching des articles
- ✅ Code splitting

## Lancer l'exemple

```bash
cd examples/blog
dart pub get
ssr build
ssr serve
```

Visitez [http://localhost:3000](http://localhost:3000)
