import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemeState extends Equatable {
  final ThemeMode themeMode;
  final ThemeData lightTheme;
  final ThemeData darkTheme;

  const ThemeState({
    required this.themeMode,
    required this.lightTheme,
    required this.darkTheme,
  });

  @override
  List<Object> get props => [themeMode, lightTheme, darkTheme];
}
