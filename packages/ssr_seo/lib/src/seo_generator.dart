import 'package:ssr_core/ssr_core.dart';

/// SEO generator for sitemap and robots.txt
class SeoGenerator {
  final String baseUrl;
  final List<SsrPage> pages;

  SeoGenerator(this.baseUrl, this.pages);

  /// Generate sitemap.xml
  String generateSitemap() {
    final buffer = StringBuffer();
    buffer.writeln('<?xml version="1.0" encoding="UTF-8"?>');
    buffer.writeln('<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">');

    for (final page in pages) {
      buffer.writeln('  <url>');
      buffer.writeln('    <loc>$baseUrl${page.path}</loc>');
      buffer.writeln('    <changefreq>weekly</changefreq>');
      buffer.writeln('    <priority>${_getPriority(page.path)}</priority>');
      buffer.writeln('  </url>');
    }

    buffer.writeln('</urlset>');
    return buffer.toString();
  }

  /// Generate robots.txt
  String generateRobotsTxt() {
    return '''
User-agent: *
Allow: /

Sitemap: $baseUrl/sitemap.xml
''';
  }

  String _getPriority(String path) {
    if (path == '/') return '1.0';
    if (path == '/about') return '0.5';
    return '0.8';
  }
}
