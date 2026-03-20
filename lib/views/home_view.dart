import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidebarx/sidebarx.dart';
import '../controllers/auth_controller.dart';
import '../shared/constants.dart';
import 'bottom_navigation/settings_view.dart';
import 'package:recruitment_mobile/utils/helper.dart';

class NavItem {
  final String title;
  final IconData icon;
  final Widget page;

  const NavItem({
    required this.title,
    required this.icon,
    required this.page,
  });
}

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final controller = Get.find<AuthController>();
  final _sidebarController = SidebarXController(selectedIndex: 0, extended: true);
  final RxInt _selectedIndex = 0.obs;
  final List<NavItem> navItems = [
    NavItem(
      title: "Dashboard",
      icon: Icons.dashboard_rounded,
      page: _DashboardPage(),
    ),
    NavItem(
      title: "Profile",
      icon: Icons.person_rounded,
      page: _ProfilePage(),
    ),
    NavItem(
      title: "Settings",
      icon: Icons.settings_rounded,
      page: SettingsView(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Obx(() => Helper.sampleAppBar(navItems[_selectedIndex.value].title, context, null)),
      ),
      body: Obx(() => navItems[_selectedIndex.value].page),
      drawer: _buildSidebar(context),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: _selectedIndex.value,
        onTap: (index) {
          _selectedIndex.value = index;
          _sidebarController.selectIndex(index);
        },
        items: navItems.map((item) {
          return BottomNavigationBarItem(
            icon: Icon(item.icon),
            label: item.title,
          );
        }).toList(),
      ),
      ),
    );
  }

  /// ────────── SidebarX Build Logic ──────────
  Widget _buildSidebar(BuildContext context) {
    return SidebarX(
      controller: _sidebarController,
      animationDuration: const Duration(milliseconds: 200),
      theme: getSidebarXStyle(context, extended: false),
      extendedTheme: getSidebarXStyle(context, extended: true),
      headerBuilder: (context, extended) => _buildSidebarHeader(extended),
      headerDivider: Divider(color: Get.theme.dividerColor),
      footerDivider: Divider(color: Get.theme.dividerColor),
      items: navItems.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        return SidebarXItem(
          icon: item.icon,
          label: item.title.tr,
          onTap: () {
            _selectedIndex.value = index;
            _sidebarController.selectIndex(index);
          },
        );
      }).toList(),
    );
  }

  Widget _buildSidebarHeader(bool extended) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(vertical: extended ? 24 : 16),
      child: Column(
        children: [
          Container(
            width: extended ? 85 : 45,
            height: extended ? 85 : 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.teal.withAlpha((0.1 * 255).toInt()), width: 2),
              boxShadow: [
                BoxShadow(color: Colors.teal.withAlpha((0.08 * 255).toInt()), blurRadius: 10)
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Image.asset(
                'assets/app_icon/khawin_logo.jpg',
                fit: BoxFit.cover,
                // Fallback icon if asset is missing
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.person, color: Colors.teal, size: extended ? 40 : 20),
              ),
            ),
          ),
          if (extended) ...[
            const SizedBox(height: 12),
            const Text(
              "Khawin Admin",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal, fontSize: 16),
            ),
            Text(
              "ADMIN PANEL",
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
          ]
        ],
      ),
    );
  }
}

SidebarXTheme getSidebarXStyle(BuildContext context, {bool extended = false}) {
  final bool isDark = Theme.of(context).brightness == Brightness.dark;
  final double scale = settingController.fontSize.value;
  final double contrast = settingController.contrast.value;
  final double saturation = settingController.saturation.value;

  final Color bgColor = isDark ? adjustColor(discordDarkDeep, contrast, saturation) : adjustColor(discordLightDeep, contrast, saturation);

  return SidebarXTheme(
    width: extended ? 260 : 90,
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 15,
          offset: const Offset(4, 0),
        ),
      ],
    ),
    // --- Unselected Style ---
    iconTheme: IconThemeData(size: 24, color: isDark ? discordDarkHint : discordLightHint),
    textStyle: TextStyle(
      color: isDark ? discordDarkLabel : const Color(0xFF4E5058),
      fontSize: 14 * scale,
    ),
    itemPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    itemTextPadding: const EdgeInsets.only(left: 20),

    // --- Selected Style ---
    selectedTextStyle: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 14 * scale),
    selectedItemTextPadding: const EdgeInsets.only(left: 20),
    selectedIconTheme: const IconThemeData(size: 24, color: Colors.teal),
    selectedItemDecoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: Colors.teal.withValues(alpha: 0.1),
      border: Border.all(color: Colors.teal.withValues(alpha: 0.2)),
    ),
    hoverColor: Colors.teal.withValues(alpha: 0.05),
  );
}

/// ────────── Page Content ──────────

class _DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Welcome Back!", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
          const SizedBox(height: 20),
          _TokenCard(token: auth.token),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              hintText: "Enter message...",
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Center(child: Text("User Profile Detail"));
}

class _TokenCard extends StatelessWidget {
  final RxString token;
  const _TokenCard({required this.token});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Active Token", style: TextStyle(fontWeight: FontWeight.bold)),
            const Divider(),
            Obx(() => SelectableText(
              token.value.isEmpty ? "No Token" : token.value,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            )),
          ],
        ),
      ),
    );
  }
}