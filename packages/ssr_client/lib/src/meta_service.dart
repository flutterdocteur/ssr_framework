import 'dart:html';
import 'package:angulardart/angulardart.dart';

/// Meta service for dynamic SEO tags
@Injectable()
class MetaService {
  /// Update meta tags for current route
  void updateMeta({
    required String title,
    String? description,
    String? canonical,
    Map<String, String>? ogTags,
  }) {
    // Update title
    document.title = title;
    _setMetaContent('meta-title', title);

    // Update description
    if (description != null) {
      _setMetaContent('meta-description', description);
    }

    // Update canonical
    if (canonical != null) {
      _setMetaContent('meta-canonical', canonical);
    }

    // Update Open Graph tags
    if (ogTags != null) {
      ogTags.forEach((key, value) {
        _setMetaContent('meta-og-$key', value);
      });
    }
  }

  void _setMetaContent(String id, String content) {
    final el = document.getElementById(id);
    if (el != null) {
      el.setAttribute('content', content);
    }
  }
}
