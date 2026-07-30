# Guide de déploiement

Ce guide couvre le déploiement de votre application SSR sur différentes plateformes.

## Préparation pour la production

### 1. Build de production

```bash
ssr build --release
```

Cela génère des fichiers optimisés dans `public/`.

### 2. Configuration

Créez un fichier `.env.production` :

```bash
PORT=3000
BASE_URL=https://votre-domaine.com
DEV_MODE=false
DATABASE_PATH=/var/data/app.db
```

### 3. Tests

```bash
# Tests unitaires
dart test

# Tests d'intégration
dart test test/integration_test.dart
```

## Déploiement sur serveur dédié

### 1. Préparer le serveur

```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install -y dart nginx

# Créer un utilisateur dédié
sudo useradd -m -s /bin/bash ssruser
sudo su - ssruser
```

### 2. Déployer l'application

```bash
# Cloner le projet
git clone https://github.com/flutterdocteur/my-app.git
cd my-app

# Installer les dépendances
dart pub get

# Build
ssr build --release
```

### 3. Configurer systemd

Créez `/etc/systemd/system/ssr-app.service` :

```ini
[Unit]
Description=SSR Application
After=network.target

[Service]
Type=simple
User=ssruser
WorkingDirectory=/home/ssruser/my-app
ExecStart=/usr/bin/dart run bin/server.dart
Restart=always
RestartSec=10
Environment=PORT=3000
Environment=BASE_URL=https://votre-domaine.com

[Install]
WantedBy=multi-user.target
```

Activez le service :

```bash
sudo systemctl daemon-reload
sudo systemctl enable ssr-app
sudo systemctl start ssr-app
sudo systemctl status ssr-app
```

### 4. Configurer Nginx

Créez `/etc/nginx/sites-available/ssr-app` :

```nginx
server {
    listen 80;
    server_name votre-domaine.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

Activez le site :

```bash
sudo ln -s /etc/nginx/sites-available/ssr-app /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### 5. SSL avec Let's Encrypt

```bash
sudo apt-get install certbot python3-certbot-nginx
sudo certbot --nginx -d votre-domaine.com
```

## Déploiement avec Docker

### 1. Créer le Dockerfile

```dockerfile
# Build stage
FROM dart:stable AS build
WORKDIR /app
COPY . .
RUN dart pub get
RUN dart run build_runner build --release

# Production stage
FROM dart:stable
WORKDIR /app
COPY --from=build /app .
EXPOSE 3000
ENV PORT=3000
CMD ["dart", "run", "bin/server.dart"]
```

### 2. Créer docker-compose.yml

```yaml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - PORT=3000
      - BASE_URL=https://votre-domaine.com
    volumes:
      - ./data:/app/data
    restart: unless-stopped

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./ssl:/etc/nginx/ssl
    depends_on:
      - app
    restart: unless-stopped
```

### 3. Déployer

```bash
# Build et démarrer
docker-compose up -d

# Voir les logs
docker-compose logs -f

# Arrêter
docker-compose down
```

## Déploiement sur plateformes cloud

### Google Cloud Run

```bash
# Installer gcloud
curl https://sdk.cloud.google.com | bash

# Authentifier
gcloud auth login

# Déployer
gcloud run deploy ssr-app \
  --source . \
  --port 3000 \
  --allow-unauthenticated
```

### AWS Elastic Beanstalk

```bash
# Installer AWS CLI
pip install awscli

# Initialiser
eb init

# Créer l'environnement
eb create production

# Déployer
eb deploy
```

### Heroku

Créez `Procfile` :

```
web: dart run bin/server.dart
```

Créez `heroku.yml` :

```yaml
build:
  docker:
    web: Dockerfile
run:
  web: dart run bin/server.dart
```

Déployez :

```bash
heroku create
git push heroku main
```

## Monitoring et logs

### Logs

```bash
# systemd
sudo journalctl -u ssr-app -f

# Docker
docker-compose logs -f app

# Manuellement
tail -f /var/log/ssr-app.log
```

### Health checks

Ajoutez une route de health check :

```dart
app.get('/health', (HttpRequest req, HttpResponse res) {
  return {'status': 'ok', 'timestamp': DateTime.now().toIso8601String()};
});
```

### Métriques

Intégrez Prometheus :

```dart
app.get('/metrics', (HttpRequest req, HttpResponse res) {
  return {
    'requests_total': requestCounter,
    'errors_total': errorCounter,
    'uptime_seconds': getUptime(),
  };
});
```

## Sauvegarde et restauration

### Base de données

```bash
# Sauvegarder
sqlite3 data/app.db ".backup 'backup/app-$(date +%Y%m%d).db'"

# Restaurer
sqlite3 data/app.db ".restore 'backup/app-20240101.db'"
```

### Fichiers statiques

```bash
# Sauvegarder
tar -czf backup/public-$(date +%Y%m%d).tar.gz public/

# Restaurer
tar -xzf backup/public-20240101.tar.gz
```

## Mise à jour en production

```bash
# Pull les changements
git pull origin main

# Installer les nouvelles dépendances
dart pub get

# Build
ssr build --release

# Redémarrer le service
sudo systemctl restart ssr-app
```

## Rollback

```bash
# Revenir à la version précédente
git checkout HEAD~1

# Rebuild
ssr build --release

# Redémarrer
sudo systemctl restart ssr-app
```

## Sécurité

### Checklist

- [ ] HTTPS activé
- [ ] Variables d'environnement sécurisées
- [ ] Base de données sauvegardée
- [ ] Logs configurés
- [ ] Firewall configuré
- [ ] Mises à jour automatiques
- [ ] Monitoring actif

### Headers de sécurité

```dart
app.all('*', (HttpRequest req, HttpResponse res) {
  res.headers.add('X-Frame-Options', 'DENY');
  res.headers.add('X-Content-Type-Options', 'nosniff');
  res.headers.add('X-XSS-Protection', '1; mode=block');
  res.headers.add('Referrer-Policy', 'strict-origin-when-cross-origin');
  return null;
});
```

## Prochaines étapes

- [Configuration avancée](configuration.md)
- [Best practices](best-practices.md)
- [Troubleshooting](troubleshooting.md)
