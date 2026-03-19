import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import 'bottom_navigation/settings_view.dart';

class HomeView extends StatelessWidget {
  final controller = Get.find<AuthController>();

  HomeView({super.key});

  // Bottom nav reactive index
  final RxInt _selectedIndex = 0.obs;

  final List<Widget> _pages = [
    _DashboardPage(),
    _ProfilePage(),
    SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Stack(
        children: [
          _pages[_selectedIndex.value],
        ],
      )),
      bottomNavigationBar: Obx(() => Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.2 * 255).toInt()),
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex.value,
          onTap: (index) => _selectedIndex.value = index,
          type: BottomNavigationBarType.fixed,
          // selectedItemColor: Colors.indigo.shade600,
          // unselectedItemColor: Colors.grey.shade600,
          // elevation: 5,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded),
              label: 'Settings',
            ),
          ],
        ),
      )),
    );
  }
}

/// ────────── Pages ──────────
class _DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Dashboard",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: colorScheme.onSurface,
                letterSpacing: -1.0,
              ),
            ),
            const SizedBox(height: 24),
            _TokenCard(controller: controller),
            const SizedBox(height: 24),
            TextField(
              decoration: InputDecoration(
                hintText: "Enter message...",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.indigo.shade100,
            child: Icon(Icons.person, size: 60, color: Colors.indigo.shade700),
          ),
          const SizedBox(height: 16),
          Text(
            "User Profile",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.indigo.shade800,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: controller.logout,
            icon: const Icon(Icons.logout_rounded),
            label: const Text("Sign Out"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              elevation: 3,
            ),
          ),
        ],
      ),
    );
  }
}

/// ────────── Token Card Widget ──────────
class _TokenCard extends StatelessWidget {
  final AuthController controller;
  const _TokenCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.key_rounded, color: Colors.indigo.shade600, size: 20),
                const SizedBox(width: 8),
                Text(
                  "Session Token",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Obx(() => SelectableText(controller.token.value.isEmpty ? "No token available" : controller.token.value,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                height: 1.4,
              ),
            )),
          ],
        ),
      ),
    );
  }
}