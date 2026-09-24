import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import '../providers/navigation_provider.dart';
import '../providers/store_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(61);

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final store = context.watch<StoreProvider>();
    final nav = context.watch<NavigationProvider>();

    return AppBar(
      toolbarHeight: 60,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 950;

            if (isMobile) {
              return _buildMobileBar(context, nav, store, auth);
            }

            return _buildDesktopBar(context, nav, store, auth);
          },
        ),
      ),
    );
  }

  // Mobile Top Bar (< 950px)
  Widget _buildMobileBar(
    BuildContext context,
    NavigationProvider nav,
    StoreProvider store,
    AuthProvider auth,
  ) {
    return Row(
      children: [
        // Brand Mark & Title
        InkWell(
          onTap: () => nav.navigateTo(AppRoute.home),
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Center(
                    child: Icon(Icons.auto_awesome_rounded, color: Color(0xFF38BDF8), size: 16),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'MT Alchemy',
                  style: TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.4,
                  ),
                ),
              ],
            ),
          ),
        ),

        const Spacer(),

        // Cart Icon
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              tooltip: 'Shopping Cart',
              icon: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF1E293B), size: 21),
              onPressed: () => nav.navigateTo(AppRoute.cart),
              visualDensity: VisualDensity.compact,
            ),
            if (store.cartCount > 0)
              Positioned(
                right: 4,
                top: 4,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2563EB),
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(minWidth: 15, minHeight: 15),
                  child: Text(
                    '${store.cartCount}',
                    style: const TextStyle(color: Colors.white, fontSize: 8.5, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(width: 4),

        // Mobile Menu Button (Hamburger)
        PopupMenuButton<String>(
          tooltip: 'Navigation Menu',
          icon: const Icon(Icons.menu_rounded, color: Color(0xFF0F172A), size: 22),
          offset: const Offset(0, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          onSelected: (val) async {
            if (val == 'home') nav.navigateTo(AppRoute.home);
            if (val == 'lms') nav.navigateTo(AppRoute.lms);
            if (val == 'store') nav.navigateTo(AppRoute.store);
            if (val == 'corporate') nav.navigateTo(AppRoute.corporate);
            if (val == 'eq') nav.navigateTo(AppRoute.eqDiagnostic);
            if (val == 'lab') nav.navigateTo(AppRoute.labTest);
            if (val == 'portal') {
              if (auth.currentRole == UserRole.superAdmin) {
                nav.navigateTo(AppRoute.admin);
              } else if (auth.currentRole == UserRole.trainer) {
                nav.navigateTo(AppRoute.trainer);
              } else if (auth.currentRole == UserRole.employer) {
                nav.navigateTo(AppRoute.employer);
              } else {
                nav.navigateTo(AppRoute.lms);
              }
            }
            if (val == 'logout') {
              await auth.logout();
              nav.navigateTo(AppRoute.home);
            }
          },
          itemBuilder: (context) => [
            _mobileMenuItem('home', 'Home', Icons.home_rounded, nav.currentRoute == AppRoute.home),
            _mobileMenuItem('lms', 'LMS Academy', Icons.school_rounded, nav.currentRoute == AppRoute.lms),
            _mobileMenuItem('store', 'E-Store', Icons.shopping_bag_outlined, nav.currentRoute == AppRoute.store),
            _mobileMenuItem('corporate', 'Corporate Enquiry', Icons.business_center_rounded, nav.currentRoute == AppRoute.corporate),
            _mobileMenuItem('eq', 'EQ Diagnostic', Icons.psychology_rounded, nav.currentRoute == AppRoute.eqDiagnostic),
            _mobileMenuItem('lab', 'Lab Test', Icons.verified_user_rounded, nav.currentRoute == AppRoute.labTest),
            const PopupMenuDivider(),
            if (auth.isAuthenticated) ...[
              PopupMenuItem(
                value: 'portal',
                child: Row(
                  children: [
                    const Icon(Icons.dashboard_rounded, size: 17, color: Color(0xFF2563EB)),
                    const SizedBox(width: 8),
                    Text('Open ${auth.currentRole.displayName}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout_rounded, size: 17, color: Color(0xFFEF4444)),
                    SizedBox(width: 8),
                    Text('Sign Out', style: TextStyle(color: Color(0xFFEF4444), fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ] else
              const PopupMenuItem(
                value: 'lab',
                child: Row(
                  children: [
                    Icon(Icons.login_rounded, size: 17, color: Color(0xFF0F172A)),
                    SizedBox(width: 8),
                    Text('Sign In / Register', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  PopupMenuItem<String> _mobileMenuItem(String value, String label, IconData icon, bool isSelected) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 17, color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B)),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  // Desktop Top Bar (>= 950px)
  Widget _buildDesktopBar(
    BuildContext context,
    NavigationProvider nav,
    StoreProvider store,
    AuthProvider auth,
  ) {
    return Row(
      children: [
        // Brand Identity
        InkWell(
          onTap: () => nav.navigateTo(AppRoute.home),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(Icons.auto_awesome_rounded, color: Color(0xFF38BDF8), size: 18),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'MT Alchemy',
                          style: TextStyle(
                            color: Color(0xFF0F172A),
                            fontSize: 16.5,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF2FF),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: const Color(0xFFC7D2FE)),
                          ),
                          child: const Text(
                            'PRO',
                            style: TextStyle(
                              color: Color(0xFF4338CA),
                              fontSize: 8.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      'People Development Consultancy',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 9.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 16),

        // Desktop Nav Items
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _desktopNavItem(nav, AppRoute.home, 'Home', Icons.home_rounded),
                _desktopNavItem(nav, AppRoute.lms, 'LMS Academy', Icons.school_rounded),
                _desktopNavItem(nav, AppRoute.store, 'E-Store', Icons.shopping_bag_outlined),
                _desktopNavItem(nav, AppRoute.corporate, 'Corporate Enquiry', Icons.business_center_rounded),
                _desktopNavItem(nav, AppRoute.eqDiagnostic, 'EQ Diagnostic', Icons.psychology_rounded),
                _desktopNavItem(nav, AppRoute.labTest, 'Lab Test', Icons.verified_user_rounded),

                const SizedBox(width: 14),

                // Search field
                Container(
                  width: 220,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.search_rounded, color: Color(0xFF94A3B8), size: 16),
                      const SizedBox(width: 6),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Search courses...',
                            hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 11.5),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                          ),
                          style: const TextStyle(fontSize: 12, color: Color(0xFF0F172A)),
                          onSubmitted: (_) => nav.navigateTo(AppRoute.lms),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Cart Icon
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              tooltip: 'Shopping Cart',
              icon: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF1E293B), size: 21),
              onPressed: () => nav.navigateTo(AppRoute.cart),
            ),
            if (store.cartCount > 0)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2563EB),
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(minWidth: 15, minHeight: 15),
                  child: Text(
                    '${store.cartCount}',
                    style: const TextStyle(color: Colors.white, fontSize: 8.5, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(width: 8),

        // Desktop User Menu
        if (auth.isAuthenticated)
          PopupMenuButton<String>(
            tooltip: 'Account Menu',
            offset: const Offset(0, 42),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            onSelected: (val) async {
              if (val == 'logout') {
                await auth.logout();
                nav.navigateTo(AppRoute.home);
              } else if (val == 'portal') {
                if (auth.currentRole == UserRole.superAdmin) {
                  nav.navigateTo(AppRoute.admin);
                } else if (auth.currentRole == UserRole.trainer) {
                  nav.navigateTo(AppRoute.trainer);
                } else if (auth.currentRole == UserRole.employer) {
                  nav.navigateTo(AppRoute.employer);
                } else {
                  nav.navigateTo(AppRoute.lms);
                }
              } else if (val == 'lab') {
                nav.navigateTo(AppRoute.labTest);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                enabled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      auth.currentUser?.name ?? 'Executive Learner',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
                    ),
                    Text(
                      auth.currentUser?.email ?? '',
                      style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                    ),
                    const Divider(),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'portal',
                child: Row(
                  children: [
                    const Icon(Icons.dashboard_rounded, size: 16, color: Color(0xFF2563EB)),
                    const SizedBox(width: 8),
                    Text('Open ${auth.currentRole.displayName}', style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'lab',
                child: Row(
                  children: [
                    Icon(Icons.verified_user_rounded, size: 16, color: Color(0xFF10B981)),
                    SizedBox(width: 8),
                    Text('Lab Test Authentication', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout_rounded, size: 16, color: Color(0xFFEF4444)),
                    SizedBox(width: 8),
                    Text('Sign Out', style: TextStyle(color: Color(0xFFEF4444), fontSize: 12.5, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        auth.currentUser?.name.isNotEmpty == true
                            ? auth.currentUser!.name.substring(0, 1).toUpperCase()
                            : 'U',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    auth.currentUser?.name.split(' ').first ?? 'Executive',
                    style: const TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(Icons.arrow_drop_down, color: Color(0xFF64748B), size: 16),
                ],
              ),
            ),
          )
        else
          ElevatedButton(
            onPressed: () => nav.navigateTo(AppRoute.labTest),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F172A),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              elevation: 0,
            ),
            child: const Text('Sign In', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
          ),
      ],
    );
  }

  static Widget _desktopNavItem(NavigationProvider nav, AppRoute route, String label, IconData icon) {
    final isSelected = nav.currentRoute == route;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: InkWell(
        onTap: () => nav.navigateTo(route),
        borderRadius: BorderRadius.circular(5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFEFF6FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 15,
                color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B),
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF334155),
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
