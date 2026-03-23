import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextField {
  static Widget buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String labelText,
    String? Function(String?)? validator,
    bool obscureText = false,
    Widget? suffixIcon,
    Widget? prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    bool passwordType = false,
    void Function(String)? onChanged,
    bool isRequired = false,
    bool enabled = true,
  }) {
    final theme = Theme.of(context);

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        final showClearIcon = enabled && !passwordType && value.text.isNotEmpty;

        return TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 10, right: 10),
            label: RichText(
              text: TextSpan(
                text: labelText,
                style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                children: isRequired
                    ? [
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
                  ),
                ]
                    : [],
              ),
            ),
            suffixIcon: showClearIcon ?
            IconButton(
              icon: CircleAvatar(backgroundColor: Get.theme.cardColor, radius: 10, child: const Icon(Icons.clear_rounded, size: 15)),
              onPressed: () {
                controller.clear();
                if (onChanged != null) onChanged('');
              },
            )
                : suffixIcon,
            prefixIcon: prefixIcon,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: theme.colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: theme.colorScheme.onSecondaryContainer),
            ),
          ),
          validator: validator,
          style: theme.textTheme.bodyLarge,
          onChanged: onChanged,
          enabled: enabled,
        );
      },
    );
  }
}