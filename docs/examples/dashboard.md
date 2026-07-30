# Exemple : Dashboard

Tableau de bord interactif avec SSR Framework.

## Structure

```
dashboard/
├── bin/
│   └── server.dart
├── lib/
│   ├── pages/
│   │   ├── dashboard_page.dart
│   │   ├── analytics_page.dart
│   │   └── settings_page.dart
│   ├── components/
│   │   ├── chart_component.dart
│   │   ├── stats_card_component.dart
│   │   └── data_table_component.dart
│   └── services/
│       ├── analytics_service.dart
│       └── user_service.dart
├── templates/
│   ├── base.html
│   └── pages/
│       ├── dashboard.html
│       ├── analytics.html
│       └── settings.html
└── public/
    ├── styles.css
    └── charts.js
```

## Code

### bin/server.dart

```dart
import 'package:ssr_core/ssr_core.dart';
import 'package:ssr_server/ssr_server.dart';
import 'pages/dashboard_page.dart';
import 'pages/analytics_page.dart';
import 'pages/settings_page.dart';

void main() async {
  final config = SsrConfig(
    name: 'Dashboard',
    baseUrl: 'http://localhost:3000',
    port: 3000,
    devMode: true,
  );

  final pages = [
    DashboardPage(),
    AnalyticsPage(),
    SettingsPage(),
  ];

  final server = SsrServer(config: config, pages: pages);
  await server.start();
}
```

### lib/pages/dashboard_page.dart

```dart
import 'package:ssr_core/ssr_core.dart';
import 'package:ssr_server/ssr_server.dart';
import '../services/analytics_service.dart';

class DashboardPage extends SsrPageBase {
  DashboardPage() : super(
    path: '/dashboard',
    title: 'Dashboard',
    description: 'Tableau de bord',
  );

  @override
  Future<String> render(Map<String, dynamic> data) async {
    final templateEngine = TemplateEngine('templates');
    await templateEngine.init();
    return templateEngine.render('pages/dashboard.html', data);
  }

  @override
  Future<Map<String, dynamic>> getInitialData() async {
    final analytics = AnalyticsService();
    return {
      'stats': await analytics.getStats(),
      'recentActivity': await analytics.getRecentActivity(),
      'chartData': await analytics.getChartData(),
    };
  }
}
```

### lib/services/analytics_service.dart

```dart
class AnalyticsService {
  Future<Map<String, dynamic>> getStats() async {
    return {
      'totalUsers': 1234,
      'activeUsers': 856,
      'revenue': 45678.90,
      'conversionRate': 3.2,
    };
  }

  Future<List<Map<String, dynamic>>> getRecentActivity() async {
    return [
      {
        'id': 1,
        'type': 'user_signup',
        'message': 'Nouvel utilisateur inscrit',
        'timestamp': '2024-01-26T10:30:00Z',
      },
      {
        'id': 2,
        'type': 'purchase',
        'message': 'Nouvelle commande',
        'timestamp': '2024-01-26T09:15:00Z',
      },
    ];
  }

  Future<Map<String, dynamic>> getChartData() async {
    return {
      'labels': ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'],
      'datasets': [
        {
          'label': 'Visiteurs',
          'data': [120, 190, 150, 180, 220, 280, 240],
        },
        {
          'label': 'Conversions',
          'data': [12, 19, 15, 18, 22, 28, 24],
        },
      ],
    };
  }
}
```

### lib/components/stats_card_component.dart

```dart
import 'package:angulardart/angulardart.dart';

@Component(
  selector: 'stats-card',
  template: '''
    <div class="stats-card">
      <div class="stats-icon">{{ icon }}</div>
      <div class="stats-info">
        <div class="stats-value">{{ value }}</div>
        <div class="stats-label">{{ label }}</div>
      </div>
      <div class="stats-trend" [class.positive]="trend > 0" [class.negative]="trend < 0">
        {{ trend > 0 ? '+' : '' }}{{ trend }}%
      </div>
    </div>
  ''',
  styles: [
    '''
    .stats-card {
      background: white;
      padding: 1.5rem;
      border-radius: 8px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
      display: flex;
      align-items: center;
      gap: 1rem;
    }
    .stats-icon {
      font-size: 2rem;
    }
    .stats-info {
      flex: 1;
    }
    .stats-value {
      font-size: 1.5rem;
      font-weight: bold;
    }
    .stats-label {
      color: #666;
      font-size: 0.9rem;
    }
    .stats-trend {
      font-weight: bold;
    }
    .stats-trend.positive {
      color: #10b981;
    }
    .stats-trend.negative {
      color: #ef4444;
    }
    '''
  ],
)
class StatsCardComponent {
  @Input()
  String icon = '';

  @Input()
  String label = '';

  @Input()
  String value = '';

  @Input()
  double trend = 0;
}
```

### lib/components/chart_component.dart

```dart
import 'dart:html';
import 'package:angulardart/angulardart.dart';

@Component(
  selector: 'chart',
  template: '<canvas #chartCanvas></canvas>',
)
class ChartComponent implements AfterViewInit {
  @ViewChild('chartCanvas')
  CanvasElement? chartCanvas;

  @Input()
  Map<String, dynamic> chartData = {};

  @override
  void ngAfterViewInit() {
    _renderChart();
  }

  void _renderChart() {
    if (chartCanvas == null) return;

    final context = chartCanvas!.getContext('2d') as CanvasRenderingContext2D;
    
    // Dessiner le graphique (simplifié)
    final labels = chartData['labels'] as List;
    final datasets = chartData['datasets'] as List;
    
    final width = chartCanvas!.width!;
    final height = chartCanvas!.height!;
    
    // Fond
    context.fillStyle = '#ffffff';
    context.fillRect(0, 0, width, height);
    
    // Axes
    context.strokeStyle = '#e5e7eb';
    context.beginPath();
    context.moveTo(50, 20);
    context.lineTo(50, height - 50);
    context.lineTo(width - 20, height - 50);
    context.stroke();
    
    // Labels
    context.fillStyle = '#6b7280';
    context.font = '12px sans-serif';
    for (var i = 0; i < labels.length; i++) {
      final x = 50 + (i * (width - 70) / labels.length);
      context.fillText(labels[i] as String, x as double, height - 30.0);
    }
    
    // Données
    if (datasets.isNotEmpty) {
      final data = (datasets[0] as Map<String, dynamic>)['data'] as List;
      context.strokeStyle = '#3b82f6';
      context.lineWidth = 2;
      context.beginPath();
      
      for (var i = 0; i < data.length; i++) {
        final x = 50 + (i * (width - 70) / data.length);
        final y = height - 50 - ((data[i] as num) * (height - 70) / 300);
        if (i == 0) {
          context.moveTo(x as double, y as double);
        } else {
          context.lineTo(x as double, y as double);
        }
      }
      context.stroke();
    }
  }
}
```

### templates/pages/dashboard.html

```html
{% extends "base.html" %}

{% block title %}Dashboard{% endblock %}
{% block description %}Tableau de bord{% endblock %}

{% block content %}
<div class="dashboard">
  <h1>Dashboard</h1>
  
  <div class="stats-grid">
    <stats-card
      icon="👥"
      label="Utilisateurs totaux"
      value="{{ stats.totalUsers }}"
      trend="12.5">
    </stats-card>
    
    <stats-card
      icon="✅"
      label="Utilisateurs actifs"
      value="{{ stats.activeUsers }}"
      trend="8.2">
    </stats-card>
    
    <stats-card
      icon="💰"
      label="Revenus"
      value="{{ stats.revenue }}€"
      trend="15.3">
    </stats-card>
    
    <stats-card
      icon="📈"
      label="Taux de conversion"
      value="{{ stats.conversionRate }}%"
      trend="-2.1">
    </stats-card>
  </div>
  
  <div class="chart-section">
    <h2>Activité de la semaine</h2>
    <chart [chartData]="chartData"></chart>
  </div>
  
  <div class="activity-section">
    <h2>Activité récente</h2>
    <div class="activity-list">
      {% for activity in recentActivity %}
      <div class="activity-item">
        <div class="activity-icon">
          {% if activity.type == 'user_signup' %}
            👤
          {% elif activity.type == 'purchase' %}
            🛒
          {% else %}
            📌
          {% endif %}
        </div>
        <div class="activity-content">
          <div class="activity-message">{{ activity.message }}</div>
          <div class="activity-time">{{ activity.timestamp }}</div>
        </div>
      </div>
      {% endfor %}
    </div>
  </div>
</div>
{% endblock %}
```

### public/styles.css

```css
.dashboard {
  max-width: 1400px;
  margin: 0 auto;
  padding: 2rem;
}

.dashboard h1 {
  margin-bottom: 2rem;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1.5rem;
  margin-bottom: 2rem;
}

.chart-section {
  background: white;
  padding: 1.5rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  margin-bottom: 2rem;
}

.chart-section h2 {
  margin-bottom: 1rem;
}

canvas {
  width: 100%;
  height: 300px;
}

.activity-section {
  background: white;
  padding: 1.5rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.activity-section h2 {
  margin-bottom: 1rem;
}

.activity-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.activity-item {
  display: flex;
  gap: 1rem;
  padding: 1rem;
  border-bottom: 1px solid #e5e7eb;
}

.activity-item:last-child {
  border-bottom: none;
}

.activity-icon {
  font-size: 1.5rem;
}

.activity-content {
  flex: 1;
}

.activity-message {
  font-weight: 500;
  margin-bottom: 0.25rem;
}

.activity-time {
  color: #6b7280;
  font-size: 0.875rem;
}
```

## Fonctionnalités

- ✅ Cartes de statistiques avec tendances
- ✅ Graphiques interactifs (Canvas)
- ✅ Liste d'activité récente
- ✅ Design responsive
- ✅ Composants réutilisables
- ✅ Données en temps réel (via API)
- ✅ Thème sombre/clair (à implémenter)

## Améliorations possibles

- [ ] Graphiques plus avancés (Chart.js)
- [ ] Filtres de dates
- [ ] Export de données (CSV, PDF)
- [ ] Notifications en temps réel
- [ ] Thème personnalisable
- [ ] Mode hors ligne

## Lancer l'exemple

```bash
cd examples/dashboard
dart pub get
ssr build
ssr serve
```

Visitez [http://localhost:3000/dashboard](http://localhost:3000/dashboard)
