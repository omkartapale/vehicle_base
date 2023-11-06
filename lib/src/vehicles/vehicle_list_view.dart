import 'package:flutter/material.dart';
import 'package:vehicle_base/src/make/make_list_view.dart';
import 'package:vehicle_base/src/models/model_list_view.dart';

import '../settings/settings_view.dart';
import '../model/vehicle.dart';
import '../data/vehicle_repository.dart';
import 'vehicle_form.dart';

/// Displays a list of Vehicles.
class VehicleListView extends StatefulWidget {
  const VehicleListView({super.key});

  static const routeName = '/';

  static List<Vehicle> vehicles = VehicleRepository.loadAllVehicles();

  @override
  State<VehicleListView> createState() => _VehicleListViewState();
}

class _VehicleListViewState extends State<VehicleListView> {
  bool _isFiltered = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicles'),
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
              Navigator.restorablePushNamed(context, ModelListView.routeName);
            },
            icon: const Icon(Icons.local_car_wash_rounded),
            tooltip: 'Models',
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
        restorationId: 'vehicleListView',
        itemCount: VehicleListView.vehicles.length,
        itemBuilder: (BuildContext context, int index) {
          final vehicle = VehicleListView.vehicles[index];

          return ListTile(
            title: Text(vehicle.model),
            subtitle: Text(vehicle.vehicleDetails),
            leading: const CircleAvatar(
              // Display the Flutter Logo image asset.
              foregroundImage: AssetImage('assets/images/flutter_logo.png'),
            ),
            onTap: () => _showBottomSheetForm(context, vehicle),
            onLongPress: () => _confirmDelete(context, vehicle),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBottomSheetForm(context),
        tooltip: 'Add vehicle',
        child: const Icon(Icons.time_to_leave_rounded),
      ),
    );
  }

  Future<dynamic> _confirmDelete(BuildContext context, Vehicle vehicle) {
    final ThemeData theme = Theme.of(context);
    final TextStyle textStyle = theme.textTheme.bodyMedium!;
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Delete ${vehicle.name}?"),
        content: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  style: textStyle,
                  text: 'Once you delete, you will not be able to use '
                      'this in future. \n\nAre you sure to delete?'),
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
                'Deleted ${vehicle.name}.',
                textAlign: TextAlign.center,
              )));
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _showBottomSheetForm(BuildContext context, [Vehicle? vehicle]) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: MediaQuery.of(context).viewInsets,
            child: VehicleForm(
              vehicleItem: vehicle,
            ),
          ),
        );
      },
    );
  }
}
