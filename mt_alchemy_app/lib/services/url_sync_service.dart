import 'url_sync_io.dart' if (dart.library.html) 'url_sync_web.dart' as platform_url;

class UrlSyncService {
  static void initialize() {
    platform_url.initUrlStrategy();
  }

  static void updateUrl(String routePath) {
    platform_url.updateBrowserUrl(routePath);
  }

  static String? getInitialRoute() {
    return platform_url.getInitialBrowserRoute();
  }

  static void setupPopStateListener(void Function(String routePath) onPopRoute) {
    platform_url.setupBrowserPopStateListener(onPopRoute);
  }
}
