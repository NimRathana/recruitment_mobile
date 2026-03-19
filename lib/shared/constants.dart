// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/setting_controller.dart';
import '../storage/storage_keys.dart';

SettingController settingController = Get.find<SettingController>();
const Color firstMainThemeColor = Colors.teal;

const Color discordDarkBg = Color(0xFF313338);
const Color discordDarkSurface = Color(0xFF2B2D31);
const Color discordDarkDeep = Color(0xFF1E1F22);
const Color discordDarkText = Color(0xFFDBDEE1);
final Color lightBg = const Color(0xFFF2F3F5);
final Color lightSurface = Colors.white;
// text field
const Color discordLightDeep = Color(0xFFEBEDEF);
const Color discordLightHint = Color(0xFF5C6370);
const Color discordDarkHint = Color(0xFF949BA4);
const Color discordDarkLabel = Color(0xFFB5BAC1);
final double fontSizeScale = settingController.fontSize.value;
final contrast = settingController.contrast.value;
final saturation = settingController.saturation.value;

ThemeData lightTheme([Color? primaryColor]) {
  final baseTextTheme = defaultTextTheme();
  final Color primary = settingController.box.hasData(StorageKeys.selectedColor) ? settingController.selectedColor.value : lightSurface;

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: adjustColor(lightBg, contrast, saturation),
    colorScheme: ColorScheme.fromSeed(
      seedColor: settingController.selectedColor.value,
      brightness: Brightness.light,
      surface: adjustColor(lightSurface, contrast, saturation),
    ),
    textTheme: applyContrastToTextTheme(baseTextTheme, const Color(0xFF060607), contrast, saturation),
    appBarTheme: AppBarTheme(
      backgroundColor: adjustColor(lightBg, contrast, saturation),
      foregroundColor: Colors.black,
      elevation: 0,
      centerTitle: false, // Discord style is left-aligned
    ),
    cardTheme: CardThemeData(
      color: adjustColor(lightSurface, contrast, saturation),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: adjustColor(primary, contrast, saturation),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: adjustColor(discordLightDeep, contrast, saturation),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      hintStyle: TextStyle(
        color: discordLightHint,
        fontSize: 14 * fontSizeScale,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: adjustColor(settingController.selectedColor.value, contrast, saturation),
          width: 1.5,
        ),
      ),
      labelStyle: const TextStyle(
        color: Color(0xFF4E5058),
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

ThemeData darkTheme([Color? primaryColor]) {
  final baseTextTheme = defaultTextTheme();
  final Color primary = settingController.box.hasData(StorageKeys.selectedColor) ? settingController.selectedColor.value.withAlpha(100) : discordDarkSurface;

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: adjustColor(discordDarkBg, contrast, saturation),
    colorScheme: ColorScheme.fromSeed(
      seedColor: settingController.selectedColor.value,
      brightness: Brightness.dark,
      surface: adjustColor(discordDarkSurface, contrast, saturation),
      onSurface: adjustColor(discordDarkText, contrast, saturation),
    ),
    textTheme: applyContrastToTextTheme(baseTextTheme, discordDarkText, contrast, saturation),
    appBarTheme: AppBarTheme(
      backgroundColor: adjustColor(discordDarkBg, contrast, saturation),
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18 * settingController.fontSize.value,
      ),
    ),
    cardTheme: CardThemeData(
      color: adjustColor(discordDarkSurface, contrast, saturation),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: adjustColor(discordDarkDeep, contrast, saturation),
      selectedItemColor: Colors.white,
      unselectedItemColor: const Color(0xFF949BA4),
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: adjustColor(primary, contrast, saturation),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: adjustColor(discordDarkDeep, contrast, saturation),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      hintStyle: TextStyle(
        color: discordDarkHint,
        fontSize: 14 * fontSizeScale,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: adjustColor(settingController.selectedColor.value, contrast, saturation),
          width: 1.5,
        ),
      ),
      labelStyle: const TextStyle(
        color: discordDarkLabel,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

Color adjustColor(Color color, double contrast, double saturation) {
  contrast = contrast.clamp(0.5, 2.0);

  int adjustComponent(int value) {
    final factor = (value - 128) * contrast + 128;
    return factor.clamp(0, 255).toInt();
  }

  final contrastedColor = Color.fromARGB(
    color.alpha,
    adjustComponent(color.red),
    adjustComponent(color.green),
    adjustComponent(color.blue),
  );

  final hsl = HSLColor.fromColor(contrastedColor);
  final saturated = hsl.withSaturation((hsl.saturation * saturation).clamp(0.0, 1.0));
  return saturated.toColor();
}

TextTheme applyContrastToTextTheme(TextTheme base, Color baseColor, double contrast, double saturation) {
  final adjustedColor = adjustColor(baseColor, contrast, saturation);
  final fontSizeScale = settingController.fontSize.value;

  TextStyle? applyColor(TextStyle? style) {
    if (style == null) return null;
    return style.copyWith(
      color: adjustedColor,
      fontSize: style.fontSize != null ? style.fontSize! * fontSizeScale : null,
    );
  }

  return base.copyWith(
    displayLarge: applyColor(base.displayLarge),
    displayMedium: applyColor(base.displayMedium),
    displaySmall: applyColor(base.displaySmall),
    headlineLarge: applyColor(base.headlineLarge),
    headlineMedium: applyColor(base.headlineMedium),
    headlineSmall: applyColor(base.headlineSmall),
    titleLarge: applyColor(base.titleLarge),
    titleMedium: applyColor(base.titleMedium),
    titleSmall: applyColor(base.titleSmall),
    bodyLarge: applyColor(base.bodyLarge),
    bodyMedium: applyColor(base.bodyMedium),
    bodySmall: applyColor(base.bodySmall),
    labelLarge: applyColor(base.labelLarge),
    labelMedium: applyColor(base.labelMedium),
    labelSmall: applyColor(base.labelSmall),
  );
}

TextTheme defaultTextTheme() {
  return const TextTheme(
    displayLarge: TextStyle(fontSize: 57, height: 64 / 57, fontWeight: FontWeight.normal, letterSpacing: -0.25),
    displayMedium: TextStyle(fontSize: 45, height: 52 / 45, fontWeight: FontWeight.normal, letterSpacing: 0.0),
    displaySmall: TextStyle(fontSize: 36, height: 44 / 36, fontWeight: FontWeight.normal, letterSpacing: 0.0),

    headlineLarge: TextStyle(fontSize: 32, height: 40 / 32, fontWeight: FontWeight.normal, letterSpacing: 0.0),
    headlineMedium: TextStyle(fontSize: 28, height: 36 / 28, fontWeight: FontWeight.normal, letterSpacing: 0.0),
    headlineSmall: TextStyle(fontSize: 24, height: 32 / 24, fontWeight: FontWeight.normal, letterSpacing: 0.0),

    titleLarge: TextStyle(fontSize: 22, height: 28 / 22, fontWeight: FontWeight.normal, letterSpacing: 0.0),
    titleMedium: TextStyle(fontSize: 16, height: 24 / 16, fontWeight: FontWeight.w500, letterSpacing: 0.15),
    titleSmall: TextStyle(fontSize: 14, height: 20 / 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),

    bodyLarge: TextStyle(fontSize: 16, height: 24 / 16, fontWeight: FontWeight.normal, letterSpacing: 0.5),
    bodyMedium: TextStyle(fontSize: 14, height: 20 / 14, fontWeight: FontWeight.normal, letterSpacing: 0.25),
    bodySmall: TextStyle(fontSize: 12, height: 16 / 12, fontWeight: FontWeight.normal, letterSpacing: 0.4),

    labelLarge: TextStyle(fontSize: 14, height: 20 / 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
    labelMedium: TextStyle(fontSize: 12, height: 16 / 12, fontWeight: FontWeight.w500, letterSpacing: 0.5),
    labelSmall: TextStyle(fontSize: 11, height: 16 / 11, fontWeight: FontWeight.w500, letterSpacing: 0.5),
  );
}


