// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter_web_plugins/url_strategy.dart';

void initUrlStrategy() {
  try {
    usePathUrlStrategy();
  } catch (_) {}
}

void updateBrowserUrl(String routePath) {
  try {
    final cleanPath = routePath.startsWith('/') ? routePath : '/$routePath';
    html.window.history.pushState(null, '', cleanPath);
  } catch (_) {}
}

String? getInitialBrowserRoute() {
  try {
    // If arriving with a legacy hash like /#/labtest, immediately strip the /# and rewrite to /labtest
    final fragment = html.window.location.hash;
    if (fragment.isNotEmpty) {
      final clean = fragment.replaceFirst('#', '').replaceAll('//', '/');
      final path = clean.startsWith('/') ? clean : '/$clean';
      html.window.history.replaceState(null, '', path);
      return path;
    }
    final path = html.window.location.pathname;
    if (path != null && path.isNotEmpty && path != '/') {
      return path;
    }
  } catch (_) {}
  return null;
}

void setupBrowserPopStateListener(void Function(String routePath) onPopRoute) {
  try {
    html.window.onPopState.listen((_) {
      final current = getInitialBrowserRoute();
      if (current != null) {
        onPopRoute(current);
      }
    });
  } catch (_) {}
}
