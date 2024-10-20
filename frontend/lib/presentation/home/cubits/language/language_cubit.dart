import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

/// A Cubit for managing the application's language settings.
class LanguageCubit extends Cubit<Locale> {
  /// Constructs the LanguageCubit with an initial state set to English ('en').
  LanguageCubit() : super(const Locale('en'));

  /// Switches the application's language between English and Portuguese.
  ///
  /// If the current language is English ('en'), it emits Portuguese ('pt').
  /// If the current language is Portuguese ('pt'), it emits English ('en').
  void switchLanguage() {
    if (state.languageCode == 'en') {
      emit(const Locale('pt'));
    } else {
      emit(const Locale('en'));
    }
  }
}
