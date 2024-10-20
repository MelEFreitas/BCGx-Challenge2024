import 'package:flutter/material.dart';

/// A custom button widget designed for use within dialogs.
///
/// The [DialogButton] allows for customization of the button's label, 
/// background color, and the action that occurs when it is pressed.
class DialogButton extends StatelessWidget {
  /// The text displayed on the button.
  final String label;

  /// The background color of the button.
  final Color backgroundColor;

  /// The callback function executed when the button is pressed.
  final VoidCallback onPressed;

  /// Creates a [DialogButton] widget.
  ///
  /// The [label], [backgroundColor], and [onPressed] parameters must be 
  /// provided. The [key] parameter is optional.
  const DialogButton({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
