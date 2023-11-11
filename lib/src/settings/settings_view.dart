import 'package:flutter/material.dart';

import 'settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller});

  static const routeName = '/settings';

  final SettingsController controller;

  String themeModeValueToString(BuildContext context, ThemeMode value) {
    return {
      ThemeMode.system: 'System Theme',
      ThemeMode.light: 'Light Theme',
      ThemeMode.dark: 'Dark Theme',
    }[value]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        shadowColor: Theme.of(context).colorScheme.shadow,
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Color Scheme'.toUpperCase()),
            subtitle:
                Text(themeModeValueToString(context, controller.themeMode)),
            // subtitle: const Text('Set it to your choice or set it to '
            //     'System to adapt with system.'),

            // Glue the SettingsController to the theme selection DropdownButton.
            //
            // When a user selects a theme from the dropdown list, the
            // SettingsController is updated, which rebuilds the MaterialApp.
            trailing: DropdownButton<ThemeMode>(
              borderRadius: BorderRadius.circular(8),

              // Read the selected themeMode from the controller
              value: controller.themeMode,
              // Call the updateThemeMode method any time the user selects a theme.
              onChanged: controller.updateThemeMode,
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('System'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text('Light'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text('Dark'),
                )
              ],
            ),
          ),
          PopupMenuButton<ThemeMode>(
            padding: EdgeInsets.zero,
            offset: Offset(MediaQuery.of(context).size.width, 0),
            // position: PopupMenuPosition.under,
            initialValue: controller.themeMode,
            onSelected: (value) => controller.updateThemeMode(value),
            itemBuilder: (context) => const <PopupMenuItem<ThemeMode>>[
              PopupMenuItem<ThemeMode>(
                value: ThemeMode.system,
                child: Text('System'),
              ),
              PopupMenuItem<ThemeMode>(
                value: ThemeMode.light,
                child: Text('Light'),
              ),
              PopupMenuItem<ThemeMode>(
                value: ThemeMode.dark,
                child: Text('Dark'),
              ),
            ],
            child: ListTile(
              title: Text('Color Scheme'.toUpperCase()),
              subtitle:
                  Text(themeModeValueToString(context, controller.themeMode)),
            ),
          ),
          ListTile(
            title: Text(
              'About'.toUpperCase(),
            ),
            subtitle: const Text('Vehicle Base App'),
            onTap: () {
              showAboutDialog(
                  context: context,
                  applicationName: 'Vehicle Base',
                  applicationVersion: 'Nov 2023',
                  applicationLegalese: '\u00a9 2023 Tech4Geek Solutions');
            },
          ),
          const Spacer(),
          FilledButton(
            onPressed: () => controller.clearThemeMode(),
            child: const Text('Clear Preferences'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
