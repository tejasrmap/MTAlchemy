import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'models/user_model.dart';
import 'providers/auth_provider.dart';
import 'providers/course_provider.dart';
import 'providers/employer_provider.dart';
import 'providers/enquiry_provider.dart';
import 'providers/navigation_provider.dart';
import 'providers/store_provider.dart';
import 'screens/corporate/corporate_enquiry_screen.dart';
import 'screens/employer/employer_dashboard_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/innovation/eq_assessment_screen.dart';
import 'screens/lab_test/lab_test_screen.dart';
import 'screens/lms/certificate_view_screen.dart';
import 'screens/lms/course_catalog_screen.dart';
import 'screens/lms/course_detail_screen.dart';
import 'screens/lms/course_player_screen.dart';
import 'screens/portals/admin_portal_screen.dart';
import 'screens/portals/trainer_portal_screen.dart';
import 'screens/store/cart_screen.dart';
import 'screens/store/checkout_screen.dart';
import 'screens/store/my_digital_products_screen.dart';
import 'screens/store/order_tracking_screen.dart';
import 'screens/store/store_catalog_screen.dart';
import 'services/firebase_service.dart';
import 'services/mock_database_service.dart';
import 'services/url_sync_service.dart';
import 'widgets/custom_app_bar.dart';
import 'widgets/rbac_guard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  UrlSyncService.initialize();
  await FirebaseService().initialize();
  runApp(const MtAlchemyApp());
}

class MtAlchemyApp extends StatelessWidget {
  const MtAlchemyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CourseProvider()),
        ChangeNotifierProvider(create: (_) => StoreProvider()),
        ChangeNotifierProvider(create: (_) => EmployerProvider()),
        ChangeNotifierProvider(create: (_) => EnquiryProvider()),
      ],
      child: MaterialApp(
        title: 'MT Alchemy - People Development Consultancy',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainShellScreen(),
      ),
    );
  }
}

class MainShellScreen extends StatelessWidget {
  const MainShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<NavigationProvider>();
    final db = MockDatabaseService();

    return Scaffold(
      appBar: const CustomAppBar(),
      body: _buildSpaBody(context, nav, db),
    );
  }

  Widget _buildSpaBody(BuildContext context, NavigationProvider nav, MockDatabaseService db) {
    switch (nav.currentRoute) {
      case AppRoute.home:
        return HomeScreen(onNavigate: (index) => nav.navigateByIndex(index));

      case AppRoute.lms:
        return const CourseCatalogScreen();

      case AppRoute.courseDetail:
        final course = nav.selectedCourse ?? db.courses.first;
        return CourseDetailScreen(course: course);

      case AppRoute.coursePlayer:
        final course = nav.selectedCourse ?? db.courses.first;
        return CoursePlayerScreen(course: course);

      case AppRoute.certificate:
        final cert = nav.selectedCertificate ?? db.certificates.first;
        return CertificateViewScreen(certificate: cert);

      case AppRoute.store:
        return const StoreCatalogScreen();

      case AppRoute.cart:
        return const CartScreen();

      case AppRoute.checkout:
        return const CheckoutScreen();

      case AppRoute.myDownloads:
        return const MyDigitalProductsScreen();

      case AppRoute.orderTracking:
        final order = nav.selectedOrder ?? db.orders.first;
        return OrderTrackingScreen(order: order);

      case AppRoute.corporate:
        return const CorporateEnquiryScreen();

      case AppRoute.eqDiagnostic:
        return EqAssessmentScreen(onNavigateToCourse: (_) => nav.navigateTo(AppRoute.lms));

      case AppRoute.labTest:
        return const LabTestScreen();

      case AppRoute.employer:
        return const RBACGuard(
          allowedRoles: [UserRole.employer, UserRole.superAdmin],
          portalName: 'Corporate Employer Portal',
          child: EmployerDashboardScreen(),
        );

      case AppRoute.trainer:
        return const RBACGuard(
          allowedRoles: [UserRole.trainer, UserRole.superAdmin],
          portalName: 'Consultant / Trainer Portal',
          child: TrainerPortalScreen(),
        );

      case AppRoute.admin:
        return const RBACGuard(
          allowedRoles: [UserRole.superAdmin],
          portalName: 'Super Admin Management Portal',
          child: AdminPortalScreen(),
        );
    }
  }
}
