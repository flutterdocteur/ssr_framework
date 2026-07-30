# Exemple : Portfolio

Site portfolio personnel avec SSR Framework.

## Structure

```
portfolio/
├── bin/
│   └── server.dart
├── lib/
│   ├── pages/
│   │   ├── home_page.dart
│   │   ├── projects_page.dart
│   │   ├── project_detail_page.dart
│   │   └── contact_page.dart
│   ├── components/
│   │   ├── project_card_component.dart
│   │   ├── skill_bar_component.dart
│   │   └── contact_form_component.dart
│   └── services/
│       └── portfolio_service.dart
├── templates/
│   ├── base.html
│   └── pages/
│       ├── home.html
│       ├── projects.html
│       ├── project_detail.html
│       └── contact.html
└── public/
    ├── styles.css
    └── images/
```

## Code

### bin/server.dart

```dart
import 'package:ssr_core/ssr_core.dart';
import 'package:ssr_server/ssr_server.dart';
import 'pages/home_page.dart';
import 'pages/projects_page.dart';
import 'pages/project_detail_page.dart';
import 'pages/contact_page.dart';

void main() async {
  final config = SsrConfig(
    name: 'Mon Portfolio',
    baseUrl: 'http://localhost:3000',
    port: 3000,
    devMode: true,
  );

  final pages = [
    HomePage(),
    ProjectsPage(),
    ProjectDetailPage(),
    ContactPage(),
  ];

  final server = SsrServer(config: config, pages: pages);
  await server.start();
}
```

### lib/pages/home_page.dart

```dart
import 'package:ssr_core/ssr_core.dart';
import 'package:ssr_server/ssr_server.dart';
import '../services/portfolio_service.dart';

class HomePage extends SsrPageBase {
  HomePage() : super(
    path: '/',
    title: 'Accueil - Mon Portfolio',
    description: 'Développeur Full-Stack passionné',
  );

  @override
  Future<String> render(Map<String, dynamic> data) async {
    final templateEngine = TemplateEngine('templates');
    await templateEngine.init();
    return templateEngine.render('pages/home.html', data);
  }

  @override
  Future<Map<String, dynamic>> getInitialData() async {
    final service = PortfolioService();
    return {
      'name': 'John Doe',
      'title': 'Développeur Full-Stack',
      'bio': 'Passionné par le développement web et les nouvelles technologies',
      'skills': await service.getSkills(),
      'featuredProjects': await service.getFeaturedProjects(),
    };
  }
}
```

### lib/services/portfolio_service.dart

```dart
class PortfolioService {
  Future<List<Map<String, dynamic>>> getSkills() async {
    return [
      {'name': 'Dart', 'level': 90},
      {'name': 'AngularDart', 'level': 85},
      {'name': 'Flutter', 'level': 80},
      {'name': 'JavaScript', 'level': 85},
      {'name': 'Node.js', 'level': 75},
    ];
  }

  Future<List<Map<String, dynamic>>> getProjects() async {
    return [
      {
        'id': 1,
        'title': 'E-commerce Platform',
        'description': 'Plateforme e-commerce complète',
        'image': '/images/project1.jpg',
        'tags': ['Dart', 'AngularDart', 'Alfred'],
        'featured': true,
      },
      {
        'id': 2,
        'title': 'Task Manager',
        'description': 'Application de gestion de tâches',
        'image': '/images/project2.jpg',
        'tags': ['Flutter', 'Firebase'],
        'featured': true,
      },
    ];
  }

  Future<List<Map<String, dynamic>>> getFeaturedProjects() async {
    final projects = await getProjects();
    return projects.where((p) => p['featured'] == true).toList();
  }

  Future<Map<String, dynamic>?> getProject(int id) async {
    final projects = await getProjects();
    try {
      return projects.firstWhere((p) => p['id'] == id);
    } catch (e) {
      return null;
    }
  }
}
```

### templates/pages/home.html

```html
{% extends "base.html" %}

{% block title %}{{ name }} - {{ title }}{% endblock %}
{% block description %}{{ bio }}{% endblock %}

{% block content %}
<section class="hero">
  <h1>{{ name }}</h1>
  <p class="subtitle">{{ title }}</p>
  <p class="bio">{{ bio }}</p>
  <div class="cta-buttons">
    <a href="/projects" class="btn btn-primary">Voir mes projets</a>
    <a href="/contact" class="btn btn-secondary">Me contacter</a>
  </div>
</section>

<section class="skills">
  <h2>Compétences</h2>
  <div class="skills-grid">
    {% for skill in skills %}
    <skill-bar name="{{ skill.name }}" level="{{ skill.level }}"></skill-bar>
    {% endfor %}
  </div>
</section>

<section class="featured-projects">
  <h2>Projets en vedette</h2>
  <div class="projects-grid">
    {% for project in featuredProjects %}
    <project-card
      id="{{ project.id }}"
      title="{{ project.title }}"
      description="{{ project.description }}"
      image="{{ project.image }}"
      tags="{{ project.tags | join(',') }}">
    </project-card>
    {% endfor %}
  </div>
</section>
{% endblock %}
```

### lib/components/skill_bar_component.dart

```dart
import 'package:angulardart/angulardart.dart';

@Component(
  selector: 'skill-bar',
  template: '''
    <div class="skill">
      <div class="skill-name">{{ name }}</div>
      <div class="skill-bar">
        <div class="skill-level" [style.width.%]="level"></div>
      </div>
      <div class="skill-percent">{{ level }}%</div>
    </div>
  ''',
  styles: [
    '''
    .skill {
      margin-bottom: 1rem;
    }
    .skill-name {
      font-weight: bold;
      margin-bottom: 0.25rem;
    }
    .skill-bar {
      background: #e0e0e0;
      height: 20px;
      border-radius: 10px;
      overflow: hidden;
    }
    .skill-level {
      background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
      height: 100%;
      transition: width 1s ease-in-out;
    }
    .skill-percent {
      text-align: right;
      font-size: 0.9rem;
      color: #666;
    }
    '''
  ],
)
class SkillBarComponent {
  @Input()
  String name = '';

  @Input()
  int level = 0;
}
```

### public/styles.css

```css
.hero {
  text-align: center;
  padding: 4rem 0;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  margin: -2rem -2rem 2rem -2rem;
  padding: 4rem 2rem;
}

.hero h1 {
  font-size: 3rem;
  margin-bottom: 0.5rem;
}

.subtitle {
  font-size: 1.5rem;
  opacity: 0.9;
  margin-bottom: 1rem;
}

.bio {
  max-width: 600px;
  margin: 0 auto 2rem;
  opacity: 0.9;
}

.cta-buttons {
  display: flex;
  gap: 1rem;
  justify-content: center;
}

.btn {
  padding: 0.75rem 2rem;
  border-radius: 25px;
  text-decoration: none;
  font-weight: bold;
  transition: transform 0.2s;
}

.btn:hover {
  transform: translateY(-2px);
}

.btn-primary {
  background: white;
  color: #667eea;
}

.btn-secondary {
  background: transparent;
  color: white;
  border: 2px solid white;
}

.skills-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1.5rem;
  margin-top: 2rem;
}

.projects-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 2rem;
  margin-top: 2rem;
}
```

## Fonctionnalités

- ✅ Page d'accueil avec hero section
- ✅ Barres de compétences animées
- ✅ Grille de projets
- ✅ Page de détail de projet
- ✅ Formulaire de contact
- ✅ Design responsive
- ✅ Animations CSS
- ✅ SEO optimisé

## Lancer l'exemple

```bash
cd examples/portfolio
dart pub get
ssr build
ssr serve
```

Visitez [http://localhost:3000](http://localhost:3000)
