import 'package:flutter/material.dart';
import 'package:frontend/core/constants/theme.dart';
import 'package:frontend/presentation/home/widgtes/dialog_utils.dart';
import 'package:frontend/presentation/home/widgtes/language_switcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// A stateless widget representing the top bar of the application.
///
/// The [TopBar] widget contains a logo, a settings popup menu,
/// and a language switcher button. It is designed to provide
/// easy access to user settings like sign out and role change.
///
/// This widget uses the [AppLocalizations] class for localized strings
/// and adheres to the application's theme.
class TopBar extends StatelessWidget {
  /// Creates a [TopBar] widget.
  ///
  /// This constructor accepts an optional [key] parameter,
  /// which can be used to identify the widget in the widget tree.
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtain localized strings from the AppLocalizations class.
    final localizations = AppLocalizations.of(context)!;

    return Container(
      color: ThemeColors.lightGreen, // Background color of the top bar.
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // Padding around the content.
      height: 60.0, // Height of the top bar.
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute children evenly.
        children: [
          // Display the application logo.
          Flexible(
            child: Image.asset(
              'assets/small_clean_logo.png',
              fit: BoxFit.contain,
            ),
          ),
          // Row containing the settings menu and language switcher.
          Row(
            children: [
              // Popup menu button for settings options.
              PopupMenuButton<String>(
                color: ThemeColors.lightGrey, // Background color of the popup menu.
                icon: const Icon(
                  Icons.settings,
                  color: ThemeColors.black,
                ),
                onSelected: (value) {
                  // Handle selection from the popup menu.
                  if (value == 'sign_out') {
                    showSignOutDialog(context); // Show sign-out confirmation dialog.
                  } else if (value == 'change_role') {
                    showChangeRoleDialog(context); // Show role change dialog.
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    // Popup menu item for signing out.
                    PopupMenuItem<String>(
                      value: 'sign_out',
                      child: Row(
                        children: [
                          const Icon(Icons.logout, color: Colors.red), // Sign out icon.
                          const SizedBox(width: 8), // Space between icon and text.
                          Text(
                            localizations.signOut, // Localized sign out text.
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    // Popup menu item for changing roles.
                    PopupMenuItem<String>(
                      value: 'change_role',
                      child: Row(
                        children: [
                          const Icon(Icons.settings, color: ThemeColors.darkGreen), // Role change icon.
                          const SizedBox(width: 8), // Space between icon and text.
                          Text(
                            localizations.changeRole, // Localized change role text.
                            style: const TextStyle(color: ThemeColors.darkGreen),
                          ),
                        ],
                      ),
                    ),
                  ];
                },
              ),
              // Language switcher button.
              const LanguageSwitcherButton(),
            ],
          ),
        ],
      ),
    );
  }
}
