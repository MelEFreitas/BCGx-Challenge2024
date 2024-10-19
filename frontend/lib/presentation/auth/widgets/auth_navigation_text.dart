import 'package:flutter/material.dart';

class AuthNavigationText extends StatelessWidget {
  final String primaryText;
  final String actionText;
  final VoidCallback onTap;

  const AuthNavigationText({
    super.key,
    required this.primaryText,
    required this.actionText,
    required this.onTap,
  });

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
                  fontSize: 17
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
