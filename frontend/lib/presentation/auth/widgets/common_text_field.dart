import 'package:flutter/material.dart';
import 'package:frontend/core/constants/theme.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String? errorText;
  final bool isVisible;
  final VoidCallback? onToggleVisibility;
  final bool hasVisibilityToggle;

  const CommonTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.errorText,
    this.isVisible = true,
    this.onToggleVisibility,
    this.hasVisibilityToggle = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: ThemeColors.darkGreen
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: ThemeColors.darkGreen,
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: ThemeColors.darkGreen,
          ),
        ),
        focusColor: ThemeColors.darkGreen,
        focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: ThemeColors.darkGreen,
        ),
      ),
        errorText: errorText,
        suffixIcon: hasVisibilityToggle
            ? IconButton(
              color: ThemeColors.darkGreen,
                icon: Icon(
                  isVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: onToggleVisibility,
              )
            : null,
      ),
    );
  }
}
