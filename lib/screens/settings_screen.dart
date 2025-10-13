// lib/screens/settings_screen.dart

import 'package:flutter/material.dart';
import '../theme_management/theme_enum.dart';

class SettingsScreen extends StatefulWidget {
  final ValueChanged<ThemeOption> onThemeChange;
  final ThemeOption currentTheme;

  const SettingsScreen({
    required this.onThemeChange,
    required this.currentTheme,
    super.key,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late ThemeOption _selectedThemeOption;

  @override
  void initState() {
    super.initState();
    _selectedThemeOption = widget.currentTheme;
  }

  @override
  void didUpdateWidget(covariant SettingsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentTheme != oldWidget.currentTheme) {
      _selectedThemeOption = widget.currentTheme;
    }
  }

  void _handleThemeChange(ThemeOption newOption) {
    setState(() {
      _selectedThemeOption = newOption;
    });

    widget.onThemeChange(newOption);
  }

  @override
  Widget build(BuildContext context) {
    final bool isSystemDefault = _selectedThemeOption == ThemeOption.system;
    final bool isDarkModeEnabled = _selectedThemeOption == ThemeOption.dark;

    final bool allowsManualControl = !isSystemDefault;

    final Color textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;
    final Color subTextColor = textColor.withOpacity(0.7);


    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // 1. System Default Option (The Master Control)
          ListTile(
            title: Text(
              'Use System Default Theme',
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Enables automatic syncing with your device settings and disables manual control.',
              style: TextStyle(color: subTextColor),
            ),
            leading: Icon(Icons.settings, color: textColor),
            trailing: Switch(
              value: isSystemDefault,
              onChanged: (bool newValue) {
                ThemeOption newOption = newValue ? ThemeOption.system : ThemeOption.light;
                if (!newValue) {
                  newOption = ThemeOption.light;
                }
                _handleThemeChange(newOption);
              },
            ),
            onTap: () {
              ThemeOption newOption = isSystemDefault ? ThemeOption.light : ThemeOption.system;
              if (isSystemDefault) {
                newOption = ThemeOption.light;
              }
              _handleThemeChange(newOption);
            },
            selected: isSystemDefault,
          ),

          const Divider(),

          // 2. Dark Mode Toggle (The Manual Control)
          ListTile(
            title: Text(
              'Dark Mode',
              style: TextStyle(
                color: allowsManualControl ? textColor : Colors.grey, // Grey out when disabled
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              allowsManualControl
                  ? 'Toggle to override the default theme.'
                  : 'Manual control is disabled. Turn off "Use System Default Theme" to enable.',
              style: TextStyle(color: allowsManualControl ? subTextColor : Colors.grey[600]),
            ),
            leading: Icon(
              isDarkModeEnabled ? Icons.nights_stay : Icons.wb_sunny,
              color: allowsManualControl ? textColor : Colors.grey,
            ),
            enabled: allowsManualControl,

            trailing: Switch(
              value: isDarkModeEnabled,
              onChanged: allowsManualControl ? (bool newValue) {
                ThemeOption newOption = newValue ? ThemeOption.dark : ThemeOption.light;
                _handleThemeChange(newOption);
              } : null,
            ),

            onTap: allowsManualControl ? () {
              ThemeOption newOption = isDarkModeEnabled ? ThemeOption.light : ThemeOption.dark;
              _handleThemeChange(newOption);
            } : null,
          ),
        ],
      ),
    );
  }
}