import 'package:flutter/material.dart';
import 'package:frontend/core/constants/theme.dart';

/// A custom button widget for authentication actions.
///
/// This [AuthButton] class provides a button that can display a loading indicator
/// or a text label based on the [isLoading] state. It uses [ElevatedButton]
/// for its appearance and interaction.
class AuthButton extends StatelessWidget {
  /// The text to be displayed on the button.
  final String buttonText;

  /// The callback function to be executed when the button is pressed.
  final VoidCallback onPressed;

  /// Indicates whether the button is in a loading state.
  ///
  /// When true, a loading indicator is displayed instead of the button text.
  final bool isLoading;

  /// Creates an instance of [AuthButton].
  ///
  /// The [buttonText] and [onPressed] parameters are required, while [isLoading]
  /// is optional and defaults to false.
  const AuthButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.isLoading = false,
  });

  /// Builds the button widget.
  ///
  /// If [isLoading] is true, a [CircularProgressIndicator] is displayed;
  /// otherwise, an [ElevatedButton] with the specified text and styles is shown.
  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLoading
          ? const CircularProgressIndicator()
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                backgroundColor: ThemeColors.logoOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onPressed,
              child: Text(
                buttonText,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
    );
  }
}
