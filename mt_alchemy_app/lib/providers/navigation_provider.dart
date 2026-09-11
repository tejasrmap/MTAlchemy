import 'package:flutter/foundation.dart';
import '../models/certificate_model.dart';
import '../models/course_model.dart';
import '../models/order_model.dart';
import '../services/url_sync_service.dart';

enum AppRoute {
  home,
  lms,
  courseDetail,
  coursePlayer,
  certificate,
  store,
  cart,
  checkout,
  myDownloads,
  orderTracking,
  corporate,
  eqDiagnostic,
  labTest,
  employer,
  trainer,
  admin,
}

class NavigationProvider with ChangeNotifier {
  AppRoute _currentRoute = AppRoute.home;
  final List<AppRoute> _routeHistory = [AppRoute.home];

  Course? _selectedCourse;
  OrderModel? _selectedOrder;
  Certificate? _selectedCertificate;

  NavigationProvider() {
    // 1. Restore route from browser URL upon page refresh (F5 / Reload)
    final initialPath = UrlSyncService.getInitialRoute();
    if (initialPath != null) {
      final restored = pathToRoute(initialPath);
      _currentRoute = restored;
      _routeHistory.clear();
      _routeHistory.add(restored);
    }

    // 2. Listen to browser Back / Forward history navigation
    UrlSyncService.setupPopStateListener((path) {
      final route = pathToRoute(path);
      if (_currentRoute != route) {
        _currentRoute = route;
        notifyListeners();
      }
    });
  }

  AppRoute get currentRoute => _currentRoute;
  Course? get selectedCourse => _selectedCourse;
  OrderModel? get selectedOrder => _selectedOrder;
  Certificate? get selectedCertificate => _selectedCertificate;

  // Map route to top bar index
  int get activeNavIndex {
    switch (_currentRoute) {
      case AppRoute.home:
        return 0;
      case AppRoute.lms:
      case AppRoute.courseDetail:
      case AppRoute.coursePlayer:
      case AppRoute.certificate:
        return 1;
      case AppRoute.store:
      case AppRoute.cart:
      case AppRoute.checkout:
      case AppRoute.myDownloads:
      case AppRoute.orderTracking:
        return 2;
      case AppRoute.corporate:
        return 3;
      case AppRoute.eqDiagnostic:
        return 4;
      case AppRoute.labTest:
        return 5;
      case AppRoute.employer:
        return 6;
      case AppRoute.trainer:
        return 7;
      case AppRoute.admin:
        return 8;
    }
  }

  static String routeToPath(AppRoute route) {
    switch (route) {
      case AppRoute.home:
        return '/';
      case AppRoute.lms:
        return '/lms';
      case AppRoute.courseDetail:
        return '/course-detail';
      case AppRoute.coursePlayer:
        return '/course-player';
      case AppRoute.certificate:
        return '/certificate';
      case AppRoute.store:
        return '/store';
      case AppRoute.cart:
        return '/cart';
      case AppRoute.checkout:
        return '/checkout';
      case AppRoute.myDownloads:
        return '/my-downloads';
      case AppRoute.orderTracking:
        return '/order-tracking';
      case AppRoute.corporate:
        return '/corporate';
      case AppRoute.eqDiagnostic:
        return '/eqdiagnostic';
      case AppRoute.labTest:
        return '/labtest';
      case AppRoute.employer:
        return '/employer';
      case AppRoute.trainer:
        return '/trainer';
      case AppRoute.admin:
        return '/admin';
    }
  }

  static AppRoute pathToRoute(String path) {
    final clean = path.trim().toLowerCase().replaceAll('#', '');
    if (clean.contains('lab-test') || clean.contains('labtest')) return AppRoute.labTest;
    if (clean.contains('eq-diagnostic') || clean.contains('eq')) return AppRoute.eqDiagnostic;
    if (clean.contains('corporate') || clean.contains('enquiry')) return AppRoute.corporate;
    if (clean.contains('checkout')) return AppRoute.checkout;
    if (clean.contains('cart')) return AppRoute.cart;
    if (clean.contains('my-downloads') || clean.contains('downloads')) return AppRoute.myDownloads;
    if (clean.contains('order-tracking') || clean.contains('tracking')) return AppRoute.orderTracking;
    if (clean.contains('store')) return AppRoute.store;
    if (clean.contains('certificate')) return AppRoute.certificate;
    if (clean.contains('course-player') || clean.contains('player')) return AppRoute.coursePlayer;
    if (clean.contains('course-detail') || clean.contains('detail')) return AppRoute.courseDetail;
    if (clean.contains('lms') || clean.contains('courses')) return AppRoute.lms;
    if (clean.contains('employer')) return AppRoute.employer;
    if (clean.contains('trainer')) return AppRoute.trainer;
    if (clean.contains('admin')) return AppRoute.admin;
    return AppRoute.home;
  }

  void navigateTo(
    AppRoute route, {
    Course? course,
    OrderModel? order,
    Certificate? certificate,
  }) {
    if (course != null) _selectedCourse = course;
    if (order != null) _selectedOrder = order;
    if (certificate != null) _selectedCertificate = certificate;

    if (_currentRoute != route) {
      _routeHistory.add(route);
      _currentRoute = route;
      // Synchronize browser address bar URL
      UrlSyncService.updateUrl(routeToPath(route));
      notifyListeners();
    }
  }

  void navigateByIndex(int index) {
    switch (index) {
      case 0:
        navigateTo(AppRoute.home);
        break;
      case 1:
        navigateTo(AppRoute.lms);
        break;
      case 2:
        navigateTo(AppRoute.store);
        break;
      case 3:
        navigateTo(AppRoute.corporate);
        break;
      case 4:
        navigateTo(AppRoute.eqDiagnostic);
        break;
      case 5:
        navigateTo(AppRoute.labTest);
        break;
      case 6:
        navigateTo(AppRoute.employer);
        break;
      case 7:
        navigateTo(AppRoute.trainer);
        break;
      case 8:
        navigateTo(AppRoute.admin);
        break;
      default:
        navigateTo(AppRoute.home);
    }
  }

  bool canGoBack() => _routeHistory.length > 1;

  void goBack() {
    if (_routeHistory.length > 1) {
      _routeHistory.removeLast();
      _currentRoute = _routeHistory.last;
      UrlSyncService.updateUrl(routeToPath(_currentRoute));
      notifyListeners();
    } else {
      _currentRoute = AppRoute.home;
      UrlSyncService.updateUrl(routeToPath(_currentRoute));
      notifyListeners();
    }
  }
}
