import 'package:flutter/material.dart';

import '../data/make_repository.dart';
import '../data/vehicle_repository.dart';
import '../make/make_list_view.dart';
import '../model/make.dart';
import '../model/vehicle.dart';
import '../models/model_list_view.dart';
import '../settings/settings_view.dart';
import 'vehicle_form.dart';

/// Displays a list of Vehicles.
class VehicleListView extends StatefulWidget {
  const VehicleListView({super.key});

  static const routeName = '/';

  @override
  State<VehicleListView> createState() => _VehicleListViewState();
}

class _VehicleListViewState extends State<VehicleListView> {
  final GlobalKey<FormState> _filterFormKey = GlobalKey<FormState>();
  late List<Vehicle> vehicles;
  bool _isFiltered = false;
  String? makeFilter;

  @override
  void initState() {
    super.initState();
    vehicles = VehicleRepository.loadAllVehicles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicles'),
        shadowColor: Theme.of(context).colorScheme.shadow,
        actions: [
          IconButton(
            onPressed: () => _filterDialog(context),
            icon: Icon(_isFiltered ? Icons.filter_alt_off : Icons.filter_alt),
            tooltip: 'Filter vehicles',
          ),
          PopupMenuButton(
            padding: EdgeInsets.zero,
            onSelected: (value) =>
                {Navigator.restorablePushNamed(context, value)},
            itemBuilder: (context) => const <PopupMenuItem<String>>[
              PopupMenuItem<String>(
                value: ModelListView.routeName,
                child: ListTile(
                  leading: Icon(Icons.local_car_wash_rounded),
                  title: Text('Models'),
                ),
              ),
              PopupMenuItem<String>(
                value: MakeListView.routeName,
                child: ListTile(
                  leading: Icon(Icons.factory),
                  title: Text('Makers'),
                ),
              ),
              PopupMenuItem<String>(
                value: SettingsView.routeName,
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8)
          // IconButton(
          //   onPressed: () {
          //     Navigator.restorablePushNamed(context, ModelListView.routeName);
          //   },
          //   icon: const Icon(Icons.local_car_wash_rounded),
          //   tooltip: 'Models',
          // ),
          // IconButton(
          //   onPressed: () {
          //     Navigator.restorablePushNamed(context, MakeListView.routeName);
          //   },
          //   icon: const Icon(Icons.factory),
          //   tooltip: 'Makers',
          // ),
          // IconButton(
          //   icon: const Icon(Icons.settings),
          //   onPressed: () {
          //     // Navigate to the settings page. If the user leaves and returns
          //     // to the app after it has been killed while running in the
          //     // background, the navigation stack is restored.
          //     Navigator.restorablePushNamed(context, SettingsView.routeName);
          //   },
          //   tooltip: 'Settings',
          // ),
        ],
      ),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      body: vehicles.isEmpty
          ? const Center(child: Text('No vehicles found!'))
          : ListView.builder(
              // Providing a restorationId allows the ListView to restore the
              // scroll position when a user leaves and returns to the app after it
              // has been killed while running in the background.
              restorationId: 'vehicleListView',
              itemCount: vehicles.length,
              itemBuilder: (BuildContext context, int index) {
                final vehicle = vehicles[index];
                return ListTile(
                  title: Text(vehicle.model),
                  subtitle: Text(vehicle.vehicleDetails),
                  leading: const CircleAvatar(
                    // Display the Flutter Logo image asset.
                    foregroundImage:
                        AssetImage('assets/images/flutter_logo.png'),
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
      floatingActionButtonLocation: _isFiltered
          ? FloatingActionButtonLocation.endContained
          : FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: (_isFiltered) ? 80 : 0,
        child: BottomAppBar(
          child: Card(
            elevation: 0,
            color: Colors.transparent,
            margin: const EdgeInsets.only(left: 0, right: 72),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              onTap: () => _filterDialog(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Icon(Icons.tune_rounded),
                  ),
                  Flexible(
                    child: Text(
                      '$makeFilter (${vehicles.length})',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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

  Future<dynamic> _filterDialog(BuildContext context) {
    final List<Make> makers = MakeRepository.loadAllMake();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Filter Vehicles"),
        content: Form(
          key: _filterFormKey,
          child: DropdownButtonFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            value: _isFiltered ? makeFilter : null,
            hint: const Text('Filter by Make'),
            borderRadius: BorderRadius.circular(8),
            items: makers.map((Make make) {
              return DropdownMenuItem<String>(
                value: make.name,
                child: Text(make.name),
              );
            }).toList(),
            onChanged: (value) {
              makeFilter = value;
            },
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please select Manufacturer.';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              vehicles = VehicleRepository.loadAllVehicles();
              setState(() {
                makeFilter = null;
                _isFiltered = false;
              });
              Navigator.pop(context);
            },
            child: const Text('Clear Filter'),
          ),
          FilledButton(
            onPressed: () {
              // Validate will return true if the form is valid, or false if
              // the form is invalid.
              if (_filterFormKey.currentState!.validate()) {
                vehicles = VehicleRepository.filterVehicles(make: makeFilter!);
                setState(() {
                  _isFiltered = true;
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Filter'),
          ),
        ],
      ),
    );
  }
}
