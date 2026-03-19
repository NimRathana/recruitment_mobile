import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/setting_controller.dart';
import '../../routes/app_routes.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingController>();

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(context, controller),
            const SizedBox(height: 32),

            _buildSectionTitle(context, "Appearance"),
            _buildCard(context, [
              _buildTile(
                context,
                icon: Icons.dark_mode_outlined,
                title: "Dark Mode",
                subtitle: "Adjust the app's visual theme",
                trailing: Obx(() => Transform.scale(
                  scale: 0.8,
                  child: CupertinoSwitch(
                    value: controller.isDarkMode.value ?? Get.isDarkMode,
                    activeTrackColor: Theme.of(context).colorScheme.primary,
                    // Background logic: Deep Discord grey when OFF
                    inactiveTrackColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E1F22) : Colors.black12,
                    onChanged: (bool value) {
                      controller.toggleTheme(value);
                    },
                  ),
                )),
              ),
              _buildTile(
                context,
                icon: Icons.palette_outlined,
                title: "Appearance",
                subtitle: "Indigo (Default)",
                onTap: () {
                  Get.toNamed(Routes.appearance);
                },
              ),
            ]),

            const SizedBox(height: 24),

            _buildSectionTitle(context, "Account"),
            _buildCard(context, [
              _buildTile(
                context,
                icon: Icons.person_outline_rounded,
                title: "Edit Profile",
                subtitle: "Update name and email",
                onTap: () {},
              ),
              _buildTile(
                context,
                icon: Icons.notifications_none_rounded,
                title: "Notifications",
                subtitle: "Manage alerts and sounds",
                onTap: () {},
              ),
              _buildTile(
                context,
                icon: Icons.security_outlined,
                title: "Security",
                subtitle: "Password and 2FA",
                onTap: () {},
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, SettingController controller) {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).colorScheme.primary.withAlpha((0.2 * 255).toInt()),
                child: Icon(Icons.person, size: 50, color: Theme.of(context).colorScheme.primary),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "User Name",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            "user.email@example.com",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).toInt()),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: List.generate(children.length * 2 - 1, (index) {
          if (index.isOdd) return const Divider(height: 0, thickness: 0.5);
          return children[index ~/ 2];
        }),
      ),
    );
  }

  Widget _buildTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        Widget? trailing,
        VoidCallback? onTap,
      }) {
    final color = Theme.of(context).colorScheme.primary.withAlpha((0.1 * 255).toInt());

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 22),
      ),
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
      trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
    );
  }
}