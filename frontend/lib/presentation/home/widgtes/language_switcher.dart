import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/theme.dart';
import 'package:frontend/presentation/home/cubits/language/language_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// A stateless widget that provides a button for switching the application language.
///
/// The [LanguageSwitcherButton] widget displays a language icon and provides
/// functionality to switch between available languages in the application.
/// It utilizes the [LanguageCubit] to perform the language switch operation
/// and shows a tooltip with localized text when hovered over.
///
/// This widget is designed to be easily integrated into other parts of the
/// application where language switching is required.
class LanguageSwitcherButton extends StatelessWidget {
  /// Creates a [LanguageSwitcherButton] widget.
  ///
  /// This constructor accepts an optional [key] parameter, which can be 
  /// used to identify the widget in the widget tree.
  const LanguageSwitcherButton({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtain localized strings from the AppLocalizations class.
    final localizations = AppLocalizations.of(context)!;

    return Tooltip(
      message: localizations.switchLanguage, // Tooltip message for the button.
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0), // Horizontal padding around the button.
        child: IconButton(
          color: ThemeColors.black, // Color of the icon button.
          icon: const Icon(Icons.language), // Language icon.
          iconSize: 30.0, // Size of the icon.
          onPressed: () {
            // Trigger language switch when the button is pressed.
            context.read<LanguageCubit>().switchLanguage();
          },
        ),
      ),
    );
  }
}
