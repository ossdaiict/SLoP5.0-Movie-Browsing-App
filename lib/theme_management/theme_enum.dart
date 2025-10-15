// lib/theme_management/theme_enum.dart

import 'package:flutter/material.dart';

enum ThemeOption { light, dark, system }

ThemeMode getThemeMode(ThemeOption option) {
  switch (option) {
    case ThemeOption.light:
      return ThemeMode.light;
    case ThemeOption.dark:
      return ThemeMode.dark;
    case ThemeOption.system:
      return ThemeMode.system;
  }
}