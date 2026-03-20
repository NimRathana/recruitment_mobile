import 'package:flag/flag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/setting_controller.dart';
import '../../routes/app_routes.dart';
import '../../utils/helper.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});
  static final languages = [
    {'nameKey': 'khmer', 'name': 'Khmer', 'code': FlagsCode.KH, 'locale': Locale('km', 'KH')},
    {'nameKey': 'english', 'name': 'English', 'code': FlagsCode.US, 'locale': Locale('en', 'US')},
    {'nameKey': 'french', 'name': 'French', 'code': FlagsCode.FR, 'locale': Locale('fr', 'FR')},
  ];

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final settingController = Get.find<SettingController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(context, settingController),
            const SizedBox(height: 32),

            _buildSectionTitle(context, "App Setting"),
            _buildCard(context, [
              _buildTile(
                context,
                icon: Icons.dark_mode_outlined,
                title: "Dark Mode",
                subtitle: "Adjust the app's visual theme",
                trailing: Obx(() => Transform.scale(
                  scale: 0.8,
                  child: CupertinoSwitch(
                    value: settingController.isDarkMode.value ?? Get.isDarkMode,
                    activeTrackColor: Theme.of(context).colorScheme.primary,
                    inactiveTrackColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E1F22) : Colors.black12,
                    onChanged: (bool value) {
                      settingController.toggleTheme(value);
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
              _buildTile(
                context,
                icon: Icons.language_outlined,
                title: "Language",
                subtitle: "English (Default)",
                onTap: () {
                  showLanguageBottomSheet();
                },
              ),
              _buildTile(
                context,
                icon: Icons.cleaning_services_outlined,
                title: "Clear Cache",
                subtitle: "Remove temporary files",
                onTap: () {
                  showClearCacheBottomSheet();
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

            const SizedBox(height: 10),

            _buildLogoutTile(context),
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

  Widget _buildTile(BuildContext context, { required IconData icon, required String title, required String subtitle, Widget? trailing, VoidCallback? onTap }) {
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

  Widget _buildLogoutTile(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).toInt()),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha((0.1 * 255).toInt()),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.logout_sharp, color: Colors.white, size: 20),
        ),
        title: Text("logout".tr, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, color: Colors.white)),
        onTap: () {
          Helper.showLogoutDialog(context);
        },
      ),
    );
  }

  void showLanguageBottomSheet() {
    Get.bottomSheet(
      SafeArea(
        bottom: true,
        child: Obx(() => Container(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 15),
          decoration: BoxDecoration(
            color: Get.theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              Text("select_language".tr, style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: Get.height * 0.5,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Get.theme.cardColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    children: List.generate(SettingsView.languages.length, (index) {
                      final lang = SettingsView.languages[index];
                      final isLast = index == SettingsView.languages.length - 1;

                      return Column(
                        children: [
                          ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: Flag.fromCode(
                                lang['code'] as FlagsCode,
                                width: 30,
                                height: 20,
                                fit: BoxFit.fill,
                              ),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(lang['name'] as String),
                                Text((lang['nameKey'] as String).tr, style: Get.textTheme.labelMedium?.copyWith(color: Colors.grey)),
                              ],
                            ),
                            trailing: Radio<String>(
                              value: lang['name'] as String,
                              groupValue: settingController.selectedLanguage.value,
                              onChanged: (value) {
                                if (value != null) {
                                  settingController.setLanguage(value);
                                  Get.updateLocale(lang['locale'] as Locale);
                                }
                              },
                            ),
                            onTap: () {
                              settingController.setLanguage(lang['name'] as String);
                              Get.updateLocale(lang['locale'] as Locale);
                            },
                          ),
                          if (!isLast) const Divider(height: 1),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
      isScrollControlled: true,
    );
  }

  void showClearCacheBottomSheet() {
    Get.bottomSheet(
      SafeArea(
        bottom: true,
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 15),
          decoration: BoxDecoration(
            color: Get.theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            border: Border.all(color: Theme.of(context).dividerColor.withAlpha(100)),
          ),
          child: Wrap(
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),

              // Title
              Center(
                child: Text("clear_caches".tr, style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 40),

              // Message
              Center(
                child: Text("clear_caches_confirmation".tr, style: Get.textTheme.bodyMedium),
              ),
              const SizedBox(height: 40),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text("cancel".tr, style: Get.textTheme.labelMedium),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        Get.snackbar(
                            '', '',
                            titleText: Center(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.layers_clear_sharp, color: Theme.of(context).dividerColor, size: 18),
                                    SizedBox(width: 8),
                                    Text('caches_cleared'.tr, style: TextStyle(color: Theme.of(context).dividerColor)),
                                  ],
                                ),
                              ),
                            ),
                            maxWidth: Get.width * .9,
                            backgroundColor: Colors.transparent,
                            snackPosition: SnackPosition.TOP,
                            snackStyle: SnackStyle.FLOATING,
                            padding: EdgeInsets.zero,
                            duration: const Duration(milliseconds: 1500),
                            isDismissible: false,
                            animationDuration: const Duration(milliseconds: 200),
                            overlayBlur: 0.0,
                            barBlur: 0.0,
                            boxShadows: [],
                            overlayColor: Colors.transparent
                        );
                        settingController.clearStorage();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                      ),
                      child: Text("clear".tr, style: Get.textTheme.labelMedium?.copyWith(color: Colors.white)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}