import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AuthLayout extends StatelessWidget {
  final String title;
  final List<Widget> formFields;
  final String switchText;
  final String switchButtonText;
  final VoidCallback onSwitchTap;
  final String actionButtonText;
  final VoidCallback onActionTap;
  final bool isLoading;

  const AuthLayout({
    super.key,
    required this.title,
    required this.formFields,
    required this.switchText,
    required this.switchButtonText,
    required this.onSwitchTap,
    required this.actionButtonText,
    required this.onActionTap,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;
    final containerWidth = isWideScreen ? 400.0 : screenWidth * 0.9;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              width: containerWidth,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xff2A4ECA),
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ...formFields,
                  const SizedBox(height: 20),
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(
                          text: switchText,
                          style: const TextStyle(
                              color: Color(0xff3B4054),
                              fontWeight: FontWeight.w500)),
                      TextSpan(
                          text: switchButtonText,
                          style: const TextStyle(
                              color: Color(0xff3461FD),
                              fontWeight: FontWeight.w500),
                          recognizer: TapGestureRecognizer()
                            ..onTap = onSwitchTap),
                    ]),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: isLoading ? null : onActionTap,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.0,
                            ),
                          )
                        : Text(actionButtonText),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
