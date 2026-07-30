import 'package:ssr_core/ssr_core.dart';
import 'package:ssr_server/ssr_server.dart';

class ProfilePage extends SsrDynamicPage {
  ProfilePage() : super(
    path: '/profile/:id',
    pattern: '/profile/:id',
    title: 'Profil - SSR Example',
    description: 'Page de profil utilisateur',
  );

  @override
  Map<String, String> extractParams(String actualPath) {
    final match = RegExp(r'/profile/(\d+)').firstMatch(actualPath);
    if (match != null) {
      return {'id': match.group(1)!};
    }
    return {};
  }

  @override
  Future<String> render(Map<String, dynamic> data) async {
    final templateEngine = TemplateEngine('templates');
    await templateEngine.init();
    return templateEngine.render('pages/profile.html', data);
  }

  @override
  Future<Map<String, dynamic>> getInitialData() async {
    return {
      'profile': {'id': 1, 'name': 'Alice', 'bio': 'Developer'},
    };
  }
}
