import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(themeMode: ThemeMode.system));

  void updateTheme(Brightness brightness) {
    final themeMode =
        brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
    emit(ThemeState(themeMode: themeMode));
  }
}
