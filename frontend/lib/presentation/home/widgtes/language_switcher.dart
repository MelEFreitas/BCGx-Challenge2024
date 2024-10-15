import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/home/cubits/language/language_cubit.dart';

class LanguageSwitcherButton extends StatelessWidget {
  const LanguageSwitcherButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Switch Language',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: IconButton(
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
