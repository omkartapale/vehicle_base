import 'package:flutter/material.dart';

import '../models/model_list_view.dart';
import '../settings/settings_view.dart';
import '../model/make.dart';
import '../data/make_repository.dart';

/// Displays a list of Vehicles.
class MakeListView extends StatelessWidget {
  const MakeListView({super.key});

  static const routeName = '/makes';

  static List<Make> makers = MakeRepository.loadAllMake();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Makers'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.restorablePushNamed(context, ModelListView.routeName);
            },
            icon: const Icon(Icons.local_car_wash_rounded),
            tooltip: 'Models',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
            tooltip: 'Settings',
          ),
        ],
      ),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      body: ListView.builder(
        // Providing a restorationId allows the ListView to restore the
        // scroll position when a user leaves and returns to the app after it
        // has been killed while running in the background.
        restorationId: 'makeListView',
        itemCount: makers.length,
        itemBuilder: (BuildContext context, int index) {
          final make = makers[index];

          return ListTile(
            title: Text(make.make),
            leading: const CircleAvatar(
              // Display the Flutter Logo image asset.
              foregroundImage: AssetImage('assets/images/flutter_logo.png'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add maker',
        child: const Icon(Icons.factory),
      ),
    );
  }
}
