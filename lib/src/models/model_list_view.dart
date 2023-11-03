import 'package:flutter/material.dart';
import 'package:vehicle_base/src/make/make_list_view.dart';

import '../settings/settings_view.dart';
import '../model/model.dart';
import '../data/model_repository.dart';

/// Displays a list of Vehicles.
class ModelListView extends StatefulWidget {
  const ModelListView({super.key});

  static const routeName = '/models';

  static List<Model> models = ModelRepository.loadAllModels();

  @override
  State<ModelListView> createState() => _ModelListViewState();
}

class _ModelListViewState extends State<ModelListView> {
  bool _isFiltered = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Models'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isFiltered = !_isFiltered;
              });
            },
            icon: Icon(_isFiltered ? Icons.filter_alt_off : Icons.filter_alt),
            tooltip: 'Filter models',
          ),
          IconButton(
            onPressed: () {
              Navigator.restorablePushNamed(context, MakeListView.routeName);
            },
            icon: const Icon(Icons.factory),
            tooltip: 'Makers',
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
        restorationId: 'modelListView',
        itemCount: ModelListView.models.length,
        itemBuilder: (BuildContext context, int index) {
          final model = ModelListView.models[index];

          return ListTile(
            title: Text(model.model),
            subtitle: Text(model.make),
            leading: const CircleAvatar(
              // Display the Flutter Logo image asset.
              foregroundImage: AssetImage('assets/images/flutter_logo.png'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add model',
        child: const Icon(Icons.local_car_wash_rounded),
      ),
    );
  }
}
