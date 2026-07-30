import 'dart:io';

/// Handler for static files
class StaticHandler {
  final String staticDir;

  StaticHandler(this.staticDir);

  /// Handle a static file request
  dynamic handle(HttpRequest req, HttpResponse res) {
    final filePath = req.uri.path.replaceFirst('/static/', '');
    final file = File('$staticDir/$filePath');
    
    if (file.existsSync()) {
      _setContentType(res, filePath);
      return file;
    }
    
    res.statusCode = 404;
    return 'File not found';
  }

  void _setContentType(HttpResponse res, String filePath) {
    if (filePath.endsWith('.js')) {
      res.headers.contentType = ContentType('application', 'javascript');
    } else if (filePath.endsWith('.css')) {
      res.headers.contentType = ContentType('text', 'css');
    } else if (filePath.endsWith('.json')) {
      res.headers.contentType = ContentType('application', 'json');
    } else if (filePath.endsWith('.svg')) {
      res.headers.contentType = ContentType('image', 'svg+xml');
    } else if (filePath.endsWith('.png')) {
      res.headers.contentType = ContentType('image', 'png');
    } else if (filePath.endsWith('.jpg') || filePath.endsWith('.jpeg')) {
      res.headers.contentType = ContentType('image', 'jpeg');
    } else if (filePath.endsWith('.ico')) {
      res.headers.contentType = ContentType('image', 'x-icon');
    }
  }
}
