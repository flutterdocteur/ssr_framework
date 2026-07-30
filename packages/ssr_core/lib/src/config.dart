/// Configuration for SSR application
class SsrConfig {
  /// Application name
  final String name;

  /// Base URL for the application
  final String baseUrl;

  /// Port for the server
  final int port;

  /// Enable development mode
  final bool devMode;

  /// Static files directory
  final String staticDir;

  /// Templates directory
  final String templatesDir;

  /// Enable PWA support
  final bool enablePwa;

  /// Enable SEO features
  final bool enableSeo;

  const SsrConfig({
    required this.name,
    this.baseUrl = 'http://localhost:3000',
    this.port = 3000,
    this.devMode = false,
    this.staticDir = 'public',
    this.templatesDir = 'lib/templates',
    this.enablePwa = true,
    this.enableSeo = true,
  });

  /// Create a copy with modified fields
  SsrConfig copyWith({
    String? name,
    String? baseUrl,
    int? port,
    bool? devMode,
    String? staticDir,
    String? templatesDir,
    bool? enablePwa,
    bool? enableSeo,
  }) {
    return SsrConfig(
      name: name ?? this.name,
      baseUrl: baseUrl ?? this.baseUrl,
      port: port ?? this.port,
      devMode: devMode ?? this.devMode,
      staticDir: staticDir ?? this.staticDir,
      templatesDir: templatesDir ?? this.templatesDir,
      enablePwa: enablePwa ?? this.enablePwa,
      enableSeo: enableSeo ?? this.enableSeo,
    );
  }
}
