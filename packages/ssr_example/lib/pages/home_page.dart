import 'package:ssr_core/ssr_core.dart';
import 'package:ssr_server/ssr_server.dart';

class HomePage extends SsrPageBase {
  HomePage() : super(
    path: '/',
    title: 'Accueil - SSR Example',
    description: 'Page d\'accueil de l\'application exemple',
  );

  @override
  Future<String> render(Map<String, dynamic> data) async {
    final templateEngine = TemplateEngine('templates');
    await templateEngine.init();
    return templateEngine.render('pages/home.html', data);
  }

  @override
  Future<Map<String, dynamic>> getInitialData() async {
    return {
      'profiles': [
        {'id': 1, 'name': 'Alice', 'bio': 'Developer'},
        {'id': 2, 'name': 'Bob', 'bio': 'Designer'},
      ],
    };
  }
}
