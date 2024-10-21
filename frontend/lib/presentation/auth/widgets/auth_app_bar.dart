import 'package:flutter/material.dart';
import 'package:frontend/presentation/home/widgtes/language_switcher.dart';

/// A custom AppBar widget for authentication screens.
///
/// This [AuthAppBar] class provides an AppBar with a transparent background,
/// no elevation, and includes a [LanguageSwitcherButton] in the actions area.
class AuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The language text to be displayed or used in the app bar.
  ///
  /// This text may represent the current language setting of the app.
  final String textLanguage;

  /// Creates an instance of [AuthAppBar].
  ///
  /// The [textLanguage] parameter is required to set the language context of the app bar.
  const AuthAppBar({super.key, required this.textLanguage});

  /// Builds the [AppBar] widget.
  ///
  /// The [AppBar] has a transparent background, no leading widget,
  /// and a [LanguageSwitcherButton] as an action in the top-right corner.
  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: const [
        LanguageSwitcherButton(),
      ],
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  /// Returns the preferred size of the [AppBar].
  ///
  /// The height is set to the default toolbar height defined by [kToolbarHeight].
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
