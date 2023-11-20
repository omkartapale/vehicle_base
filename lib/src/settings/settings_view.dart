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
          Container(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
            alignment: Alignment.centerLeft,
            child: Text(
              'Color Scheme'.toUpperCase(),
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
          ),
          // ListTile(
          //   title: const Text('Theme'),
          //   subtitle:
          //       Text(themeModeValueToString(context, controller.themeMode)),
          //   // subtitle: const Text('Set it to your choice or set it to '
          //   //     'System to adapt with system.'),

          //   // Glue the SettingsController to the theme selection DropdownButton.
          //   //
          //   // When a user selects a theme from the dropdown list, the
          //   // SettingsController is updated, which rebuilds the MaterialApp.
          //   trailing: DropdownButton<ThemeMode>(
          //     borderRadius: BorderRadius.circular(8),

          //     // Read the selected themeMode from the controller
          //     value: controller.themeMode,
          //     // Call the updateThemeMode method any time the user selects a theme.
          //     onChanged: controller.updateThemeMode,
          //     items: const [
          //       DropdownMenuItem(
          //         value: ThemeMode.system,
          //         child: Text('System'),
          //       ),
          //       DropdownMenuItem(
          //         value: ThemeMode.light,
          //         child: Text('Light'),
          //       ),
          //       DropdownMenuItem(
          //         value: ThemeMode.dark,
          //         child: Text('Dark'),
          //       )
          //     ],
          //   ),
          // ),
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
              title: const Text('Theme'),
              subtitle:
                  Text(themeModeValueToString(context, controller.themeMode)),
            ),
          ),
          const Divider(indent: 16.0, endIndent: 16.0),
          Container(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
            alignment: Alignment.centerLeft,
            child: Text(
              'About'.toUpperCase(),
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
          ),
          const ListTile(
            isThreeLine: true,
            title: Text('Indian Vehicles Base Dataset'),
            subtitle: Text('\nMake, Model and Variant recording app\n'
                '\u00a9 2023 Tech4Geek Solutions\n\n'
                'Version: Nov 2023'),
          ),
          ListTile(
            title: const Text('Licenses'),
            subtitle: const Text('Open Source licenses'),
            onTap: () {
              showLicensePage(
                context: context,
                applicationName: 'Vehicle Base',
                // applicationVersion: 'Nov 2023',
                applicationLegalese: '\u00a9 2023 Tech4Geek Solutions',
              );
            },
          ),
          const Spacer(),
          FilledButton(
            onPressed: () {
              controller.clearThemeMode();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Preferences cleared.',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
            child: const Text('Clear Preferences'),
          ),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }
}
