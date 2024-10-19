import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/theme.dart';
import 'package:frontend/presentation/home/cubits/language/language_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageSwitcherButton extends StatelessWidget {
  const LanguageSwitcherButton({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Tooltip(
      message: localizations.switchLanguage,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: IconButton(
          color: ThemeColors.black,
          icon: const Icon(Icons.language),
          iconSize: 30.0,
          onPressed: () {
            context.read<LanguageCubit>().switchLanguage();
          },
        ),
      ),
    );
  }
}
