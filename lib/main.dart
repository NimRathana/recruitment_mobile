import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:recruitment_mobile/core/constants/storage_keys.dart';
import 'package:recruitment_mobile/views/bottom_navigation/settings_view.dart';
import 'bindings/auth_binding.dart';
import 'controllers/setting_controller.dart';
import 'core/themes/app_theme.dart';
import 'translate/AppTranslations.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const env = String.fromEnvironment('ENV', defaultValue: 'dev');
  await dotenv.load(
    fileName: env == 'prod' ? '.env.prod' : '.env.dev',
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);
  await GetStorage.init();
  Get.put(SettingController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final firstPage = box.read(StorageKeys.token) != null ? Routes.home : Routes.login;
    final SettingController settingController = Get.find();
    final isDark = settingController.isDarkMode.value ?? false;
    final selectedColor = settingController.selectedColor.value;
    final selectedLang = settingController.selectedLanguage.value;
    final selectedLocale = SettingsView.languages.firstWhere((lang) => lang['name'] == selectedLang, orElse: () => {'locale': Locale('en', 'US')})['locale'] as Locale;
    return Obx(() {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialBinding: AuthBinding(),
        initialRoute: firstPage,
        translations: AppTranslations(),
        locale: selectedLocale,
        fallbackLocale: const Locale('en', 'US'),
        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
        theme: lightTheme(selectedColor),
        darkTheme: darkTheme(selectedColor),
        getPages: AppPages.routes,
      );
    });
  }
}