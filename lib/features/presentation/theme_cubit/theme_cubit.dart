import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';

enum AppThemeMode { light, dark }

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  void toggleTheme() {
    emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
  }

  void setLightTheme() => emit(ThemeMode.light);
  void setDarkTheme() => emit(ThemeMode.dark);
}
