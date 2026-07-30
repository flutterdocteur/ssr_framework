import 'config.dart';
import 'page.dart';

/// Abstract interface for an SSR application
abstract class SsrApp {
  /// Application configuration
  SsrConfig get config;

  /// List of pages in the application
  List<SsrPage> get pages;

  /// Initialize the application
  Future<void> init();

  /// Dispose resources
  Future<void> dispose();
}

/// Base implementation of SsrApp
abstract class SsrAppBase implements SsrApp {
  @override
  final SsrConfig config;

  SsrAppBase(this.config);

  @override
  Future<void> init() async {
    // Override in subclass
  }

  @override
  Future<void> dispose() async {
    // Override in subclass
  }
}
