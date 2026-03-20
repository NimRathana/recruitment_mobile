import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class Helper {
  static final authController = Get.find<AuthController>();

  static AppBar sampleAppBar(String title, BuildContext context, String? logoImg, {VoidCallback? onLogoTap}) {
    return AppBar(
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      centerTitle: true,
      actions: [
        if (logoImg != null)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              // onTap: onLogoTap ?? () {
              //   Get.to(() => MyAccount(), arguments: {'title': 'my_account'.tr});
              // },
              child: ClipOval(
                child: Image.asset(
                  logoImg,
                  height: 36,
                  width: 36,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
      ],
    );
  }

  /// Show a global logout confirmation dialog
  static void showLogoutDialog(BuildContext context) {
    Get.defaultDialog(
      radius: 10,
      contentPadding: const EdgeInsets.all(20),
      titlePadding: const EdgeInsets.only(top: 20),
      title: "logout".tr,
      titleStyle: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      content: Text(
        "logout_confirmation".tr,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      cancel: ElevatedButton(
        onPressed: () async {
          authController.logout();
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
        child: Center(
          child: Text(
            "logout".tr,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white),
          ),
        ),
      ),
      confirm: ElevatedButton(
        onPressed: () {
          Get.back();
        },
        style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).focusColor),
        child: Center(
          child: Text(
            "cancel".tr,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
      ),
    );
  }
}