import 'package:jinja/jinja.dart';
import 'package:jinja/loaders.dart';

/// Template engine for SSR
class TemplateEngine {
  final String templatesDir;
  late Environment _env;

  TemplateEngine(this.templatesDir);

  /// Initialize the template engine
  Future<void> init() async {
    _env = Environment(
      loader: FileSystemLoader(paths: [templatesDir]),
      autoReload: true,
      trimBlocks: true,
      leftStripBlocks: true,
    );
  }

  /// Render a template with context
  String render(String templateName, [Map<String, dynamic>? context]) {
    return _env.getTemplate(templateName).render(context ?? {});
  }
}
