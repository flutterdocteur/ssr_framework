import 'package:ssr_core/ssr_core.dart';
import 'package:ssr_server/ssr_server.dart';

class AboutPage extends SsrPageBase {
  AboutPage() : super(
    path: '/about',
    title: 'À propos - SSR Example',
    description: 'À propos de l\'application exemple',
  );

  @override
  Future<String> render(Map<String, dynamic> data) async {
    final templateEngine = TemplateEngine('templates');
    await templateEngine.init();
    return templateEngine.render('pages/about.html', data);
  }
}
