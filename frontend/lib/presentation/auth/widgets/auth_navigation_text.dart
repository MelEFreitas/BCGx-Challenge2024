import 'package:flutter/material.dart';

/// A widget that displays navigational text with an action link.
///
/// This [AuthNavigationText] class combines a primary text with an action text
/// that can be tapped to trigger a callback function. The action text is
/// styled differently to indicate that it is interactive.
class AuthNavigationText extends StatelessWidget {
  /// The main text displayed in the widget.
  final String primaryText;

  /// The action text that users can tap.
  final String actionText;

  /// The callback function to be executed when the action text is tapped.
  final VoidCallback onTap;

  /// Creates an instance of [AuthNavigationText].
  ///
  /// The [primaryText], [actionText], and [onTap] parameters are required.
  const AuthNavigationText({
    super.key,
    required this.primaryText,
    required this.actionText,
    required this.onTap,
  });

  /// Builds the widget.
  ///
  /// The widget displays the primary text followed by the action text,
  /// which is styled to appear as a clickable link. A mouse cursor is
  /// changed to a pointer when hovering over the text.
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: RichText(
          text: TextSpan(
            text: primaryText,
            style: const TextStyle(color: Colors.black, fontSize: 16),
            children: [
              TextSpan(
                text: actionText,
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
