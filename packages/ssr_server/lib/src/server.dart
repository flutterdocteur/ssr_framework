import 'dart:io';
import 'package:alfred/alfred.dart';
import 'package:ssr_core/ssr_core.dart';
import 'template_engine.dart';
import 'static_handler.dart';
import 'seo_handler.dart';

/// SSR Server implementation
class SsrServer {
  final SsrConfig config;
  final List<SsrPage> pages;
  late Alfred _app;
  late TemplateEngine _templateEngine;
  late StaticHandler _staticHandler;
  late SeoHandler _seoHandler;

  SsrServer({
    required this.config,
    required this.pages,
  });

  /// Start the server
  Future<void> start() async {
    _app = Alfred();
    _templateEngine = TemplateEngine(config.templatesDir);
    _staticHandler = StaticHandler(config.staticDir);
    _seoHandler = SeoHandler(config.baseUrl, pages);

    await _templateEngine.init();
    _setupMiddleware();
    _setupRoutes();
    _setupSeoRoutes();
    _setupNotFoundHandler();

    await _app.listen(config.port);
    print('SSR Server started on ${config.baseUrl}');
  }

  void _setupMiddleware() {
    // Static files middleware
    _app.all('*', (HttpRequest req, HttpResponse res) {
      if (req.uri.path.startsWith('/static/')) {
        return _staticHandler.handle(req, res);
      }
      return null;
    });

    // Request logging
    _app.all('*', (HttpRequest req, HttpResponse res) {
      print('${req.method} ${req.uri.path}');
      return null;
    });
  }

  void _setupRoutes() {
    for (final page in pages) {
      _app.get(page.path, (HttpRequest req, HttpResponse res) async {
        final data = await page.getInitialData();
        final html = await page.render(data);
        res.headers.contentType = ContentType.html;
        return html;
      });
    }
  }

  void _setupSeoRoutes() {
    if (config.enableSeo) {
      _app.get('/sitemap.xml', (HttpRequest req, HttpResponse res) {
        res.headers.contentType = ContentType('application', 'xml');
        return _seoHandler.generateSitemap();
      });

      _app.get('/robots.txt', (HttpRequest req, HttpResponse res) {
        res.headers.contentType = ContentType('text', 'plain');
        return _seoHandler.generateRobotsTxt();
      });
    }

    if (config.enablePwa) {
      _app.get('/manifest.json', (HttpRequest req, HttpResponse res) {
        res.headers.contentType = ContentType('application', 'json');
        return File('${config.staticDir}/manifest.json');
      });
    }
  }

  void _setupNotFoundHandler() {
    _app.onNotFound = (HttpRequest req, HttpResponse res) {
      res.statusCode = 404;
      res.headers.contentType = ContentType.html;
      return _templateEngine.render('pages/404.html');
    };
  }

  /// Stop the server
  Future<void> stop() async {
    await _app.close();
  }
}
