import 'package:flutter/material.dart';

import '../models/model_list_view.dart';
import '../settings/settings_view.dart';
import '../model/make.dart';
import '../data/make_repository.dart';
import 'make_form.dart';

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
            title: Text(make.name),
            leading: const CircleAvatar(
              // Display the Flutter Logo image asset.
              foregroundImage: AssetImage('assets/images/flutter_logo.png'),
            ),
            onTap: () => _showBottomSheetForm(context, make),
            onLongPress: () => _confirmDelete(context, make),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBottomSheetForm(context),
        tooltip: 'Add maker',
        child: const Icon(Icons.factory),
      ),
    );
  }

  Future<dynamic> _confirmDelete(BuildContext context, Make make) {
    final ThemeData theme = Theme.of(context);
    final TextStyle textStyle = theme.textTheme.bodyMedium!;
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Delete ${make.name}?"),
        content: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  style: textStyle,
                  text: 'Once you delete, you will not be able to use '
                      'this in future. \n\nAre you sure to delete?'),
              // TextSpan(
              //     style: textStyle.copyWith(fontWeight: FontWeight.bold),
              //     text: make.name),
              // TextSpan(style: textStyle, text: '?'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                'Deleted ${make.name}.',
                textAlign: TextAlign.center,
              )));
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _showBottomSheetForm(BuildContext context, [Make? make]) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: MediaQuery.of(context).viewInsets,
            child: MakeForm(
              makeItem: make,
            ),
          ),
        );
      },
    );
  }
}
