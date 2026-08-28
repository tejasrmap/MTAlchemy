// Platform-specific IO implementation for mobile, desktop and unit tests
void initUrlStrategy() {
  // No-op on mobile/desktop
}

void updateBrowserUrl(String routePath) {
  // No-op on mobile/desktop
}

String? getInitialBrowserRoute() {
  return null;
}

void setupBrowserPopStateListener(void Function(String routePath) onPopRoute) {
  // No-op on mobile/desktop
}
