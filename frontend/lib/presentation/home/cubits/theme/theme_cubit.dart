import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit()
      : super(ThemeState(
          themeMode: ThemeMode.system,
          lightTheme: _defaultLightTheme,
          darkTheme: _defaultDarkTheme,
        ));

  static final ThemeData _defaultLightTheme = ThemeData(
    primarySwatch: Colors.green,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(backgroundColor: Colors.green),
  );

  static final ThemeData _defaultDarkTheme = ThemeData(
    primarySwatch: Colors.green,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(backgroundColor: Colors.green.shade900),
  );

  void updateTheme(Brightness brightness) {
    final themeMode =
        brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
    emit(ThemeState(
      themeMode: themeMode,
      lightTheme: state.lightTheme,
      darkTheme: state.darkTheme,
    ));
  }

  void setCustomThemes({ThemeData? lightTheme, ThemeData? darkTheme}) {
    emit(ThemeState(
      themeMode: state.themeMode,
      lightTheme: lightTheme ?? state.lightTheme,
      darkTheme: darkTheme ?? state.darkTheme,
    ));
  }
}
