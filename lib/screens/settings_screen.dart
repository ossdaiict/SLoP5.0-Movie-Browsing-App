// lib/screens/settings_screen.dart

import 'package:flutter/material.dart';
import '../theme_management/theme_enum.dart';
import 'about_app_screen.dart';

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

    final Color textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;
    final Color subTextColor = textColor.withValues(alpha: 0.7);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // System Default Theme
          ListTile(
            title: Text(
              'Use System Default Theme',
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Automatically sync with your device theme.',
              style: TextStyle(color: subTextColor),
            ),
            leading: Icon(Icons.settings, color: textColor),
            trailing: Switch(
              value: isSystemDefault,
              onChanged: (value) {
                _handleThemeChange(
                    value ? ThemeOption.system : ThemeOption.light);
              },
            ),
            onTap: () {
              _handleThemeChange(
                  isSystemDefault ? ThemeOption.light : ThemeOption.system);
            },
          ),

          const Divider(),

          // Dark Mode
          ListTile(
            title: Text(
              'Dark Mode',
              style: TextStyle(
                color: allowsManualControl ? textColor : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              allowsManualControl
                  ? 'Override the default theme.'
                  : 'Disable system default to enable.',
              style: TextStyle(
                color: allowsManualControl
                    ? subTextColor
                    : Colors.grey[600],
              ),
            ),
            leading: Icon(
              isDarkModeEnabled ? Icons.nights_stay : Icons.wb_sunny,
              color: allowsManualControl ? textColor : Colors.grey,
            ),
            trailing: Switch(
              value: isDarkModeEnabled,
              onChanged: allowsManualControl
                  ? (value) {
                      _handleThemeChange(
                          value ? ThemeOption.dark : ThemeOption.light);
                    }
                  : null,
            ),
            enabled: allowsManualControl,
            onTap: allowsManualControl
                ? () {
                    _handleThemeChange(isDarkModeEnabled
                        ? ThemeOption.light
                        : ThemeOption.dark);
                  }
                : null,
          ),

          const Divider(),

          // ABOUT APP
          ListTile(
            leading: Icon(Icons.info_outline, color: textColor),
            title: Text(
              'About App',
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'App information, version, and credits',
              style: TextStyle(color: subTextColor),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AboutAppScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
