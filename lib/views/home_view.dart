import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recruitment_mobile/views/widgets/custom_textfield.dart';
import 'package:sidebarx/sidebarx.dart';
import '../controllers/auth_controller.dart';
import '../core/themes/app_theme.dart';
import 'bottom_navigation/settings_view.dart';
import 'package:recruitment_mobile/core/utils/helper.dart';
import 'chat_view.dart';

class NavItem {
  final String title;
  final IconData icon;
  final Widget? page;
  final bool showInBottomBar;
  final VoidCallback? onTap;

  const NavItem({
    required this.title,
    required this.icon,
    this.page,
    this.onTap,
    this.showInBottomBar = false
  });
}

class HomeView extends StatelessWidget {
  HomeView({super.key}) {
    sidebarItems = [
      NavItem(
        title: "Dashboard",
        icon: Icons.dashboard_rounded,
        page: _DashboardPage(),
        showInBottomBar: true,
      ),
      NavItem(
        title: "Profile",
        icon: Icons.person_rounded,
        page: _ProfilePage(),
        showInBottomBar: true,
      ),
      NavItem(
        title: "Setting",
        icon: Icons.settings_rounded,
        page: SettingsView(),
        showInBottomBar: true,
      ),
      NavItem(
        title: "Chat",
        icon: Icons.chat_rounded,
        page: ChatView(scaffoldKey: _scaffoldKey),
      ),
      NavItem(
        title: "logout",
        icon: Icons.logout,
        onTap: () {
          Helper.showLogoutDialog(Get.context!);
        },
      ),
    ];

    bottomNavItems = sidebarItems.where((item) => item.showInBottomBar).toList();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final controller = Get.find<AuthController>();
  final _sidebarController = SidebarXController(selectedIndex: 0, extended: true);
  final RxInt _selectedIndex = 0.obs;
  late final List<NavItem> sidebarItems;
  late final List<NavItem> bottomNavItems;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Obx(() {
          final item = sidebarItems[_selectedIndex.value];
          if (item.title == "Chat") {
            return const SizedBox.shrink();
          }
          return Helper.sampleAppBar(
            item.title.tr,
            context,
            null,
          );
        }),
      ),
      body: Obx(() => sidebarItems[_selectedIndex.value].page!),
      drawer: _buildSidebar(context),
      bottomNavigationBar: Obx(() {
        final currentItem = sidebarItems[_selectedIndex.value];
        if (!currentItem.showInBottomBar || bottomNavItems.length < 2) {
          return const SizedBox.shrink();
        }

        int currentIndex = bottomNavItems.indexOf(currentItem);
        if (currentIndex == -1) currentIndex = 0;

        return BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            final selectedItem = bottomNavItems[index];
            final realIndex = sidebarItems.indexOf(selectedItem);
            _selectedIndex.value = realIndex;
            _sidebarController.selectIndex(realIndex);
          },
          items: bottomNavItems.map((item) {
            return BottomNavigationBarItem(
              icon: Icon(item.icon),
              label: item.title.tr,
            );
          }).toList(),
        );
      }),
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
      items: sidebarItems.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final isLogout = item.title.toLowerCase() == "logout";

        return SidebarXItem(
          icon: item.icon,
          label: isLogout ? null : item.title.tr,
          selectable: !isLogout,
          iconBuilder: isLogout ? (selected, hovered) {
            return Row(
              children: [
                Icon(Icons.exit_to_app_rounded, color: Colors.red),
                AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  child: _sidebarController.extended ? Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text('logout'.tr, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  ) : const SizedBox.shrink(),
                ),
              ],
            );
          } : null,
          onTap: () {
            if (item.page != null) {
              _selectedIndex.value = index;
              _sidebarController.selectIndex(index);
            }
            if (item.onTap != null) {
              item.onTap!();
            }
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

  final Color bgColor = isDark ? adjustColor(darkDeep, contrast, saturation) : adjustColor(lightDeep, contrast, saturation);

  return SidebarXTheme(
    width: extended ? 260 : 70,
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
    iconTheme: IconThemeData(size: 24, color: isDark ? darkHint : lightHint),
    textStyle: TextStyle(
      color: isDark ? darkLabel : const Color(0xFF4E5058),
      fontSize: 14 * scale,
    ),
    itemPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    itemTextPadding: const EdgeInsets.only(left: 20),

    // --- Selected Style ---
    selectedTextStyle: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 14 * scale),
    selectedItemPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
    TextEditingController textController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Welcome Back!", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
          const SizedBox(height: 20),
          _TokenCard(token: auth.token),
          const SizedBox(height: 20),
          CustomTextField.buildTextField(
            context: context,
            controller: textController,
            labelText: "Enter Message...",
          )
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