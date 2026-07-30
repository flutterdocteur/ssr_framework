import 'package:ssr_core/ssr_core.dart';
import 'package:ssr_server/ssr_server.dart';
import 'pages/home_page.dart';
import 'pages/profile_page.dart';
import 'pages/about_page.dart';

void main() async {
  final config = SsrConfig(
    name: 'SSR Example',
    baseUrl: 'http://localhost:3000',
    port: 3000,
    devMode: true,
    staticDir: 'public',
    templatesDir: 'templates',
    enablePwa: true,
    enableSeo: true,
  );

  final pages = [
    HomePage(),
    ProfilePage(),
    AboutPage(),
  ];

  final server = SsrServer(config: config, pages: pages);
  await server.start();
}
