import 'package:flutter/material.dart';

class Helper {
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
}