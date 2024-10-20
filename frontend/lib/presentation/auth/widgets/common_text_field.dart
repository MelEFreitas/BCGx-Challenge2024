import 'package:flutter/material.dart';
import 'package:frontend/core/constants/theme.dart';

/// A customizable text field widget for user input.
///
/// The [CommonTextField] class provides a text input field with options for
/// label text, hint text, error messages, and visibility toggle for passwords.
class CommonTextField extends StatelessWidget {
  /// The controller used to retrieve the current value of the text field.
  final TextEditingController controller;

  /// The label text displayed above the text field.
  final String labelText;

  /// The hint text displayed inside the text field when it is empty.
  final String hintText;

  /// An optional error message to be displayed when input is invalid.
  final String? errorText;

  /// Indicates whether the text field is currently visible.
  ///
  /// If false, the text field will obscure its input (e.g., for passwords).
  final bool isVisible;

  /// A callback function to toggle the visibility of the text field.
  final VoidCallback? onToggleVisibility;

  /// Indicates whether to show a visibility toggle icon.
  final bool hasVisibilityToggle;

  /// Creates an instance of [CommonTextField].
  ///
  /// The [controller], [labelText], and [hintText] parameters are required.
  /// The [errorText] and [onToggleVisibility] parameters are optional.
  /// The [isVisible] parameter defaults to true, and [hasVisibilityToggle] defaults to false.
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

  /// Builds the text field widget.
  ///
  /// The widget displays a [TextFormField] with the specified properties,
  /// including label, hint, and error message. If [hasVisibilityToggle] is true,
  /// an icon button is displayed to toggle the visibility of the text input.
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: ThemeColors.darkGreen,
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
