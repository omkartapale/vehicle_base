import 'package:flutter/material.dart';

import '../model/model.dart';
import '../model/make.dart';
import '../model/vehicle.dart';
import '../data/make_repository.dart';
import '../data/model_repository.dart';

/// Creates a Vehicle information Form
///
/// Constructor receives optional param [vehicleItem] of type [Vehicle].
///
/// If [vehicleItem] is provided VehicleForm creates a form to update vehicle
/// information with populated information of provided vehicle. Else creates
/// an empty form to add new vehicle.
class VehicleForm extends StatefulWidget {
  /// Creates a form for vehicle.
  ///
  /// The [vehicleItem] argument is optional.
  const VehicleForm({super.key, this.vehicleItem});

  /// Vehicle to load information about.
  final Vehicle? vehicleItem;

  @override
  State<VehicleForm> createState() => _VehicleFormState();
}

/// State associated with a [VehicleForm] widget.
///
/// Boolean [_isNewVehicle] used to decide form should be provided to create
/// a new vehicle or update existing vehicle.
///
/// If vehicle is provided then models according to vehicle's make are populated
/// in [filteredModels] while updating existing vehicle.
/// When creating a new vehicle [filteredModels] is set to empty, and Model
/// DropdownButton is initially disabled. Once the Make is selected on the form
/// [filteredModels] are populated according to selected Make and the Model
/// DropdownButton is enabled.
class _VehicleFormState extends State<VehicleForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Boolean states that the form should be used to Create or Update vehicle.
  bool _isNewVehicle = true;

  late String? _selectedMake;
  late String? _selectedModel;

  /// List of all Manufacturer / Make
  late List<Make> makers;

  /// Filtered list of Vehicle Models from selected Make.
  ///
  /// If a vehicle is provided when loading the form or if Make is selected on
  /// the form then populate models according to Make. Else set to empty so
  /// that DropdownButton is disabled.
  late List<Model> filteredModels;

  @override
  void initState() {
    super.initState();

    // Check if vehicle is provided while loading and not null
    // and update [_isNewVehicle] accordingly.
    if (widget.vehicleItem != null) {
      setState(() {
        _isNewVehicle = false;
      });
    }
    _selectedMake = widget.vehicleItem?.make;
    _selectedModel = widget.vehicleItem?.model;

    // Populate makers list
    makers = MakeRepository.loadAllMake();

    // Check if vehicle is provided then populate models according to
    // provided vehicle's make
    filteredModels =
        (_isNewVehicle) ? [] : ModelRepository.filterModels(_selectedMake!);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                label: const Text('Make *'),
                isDense: true,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              value: _selectedMake,
              // menuMaxHeight: 400,
              hint: const Text(
                'Select Manufacturer',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              borderRadius: BorderRadius.circular(8),
              onChanged: (newValue) {
                setState(() {
                  _selectedMake = newValue;

                  // Reset selected model
                  _selectedModel = null;

                  // Populate models according to selected vehicle's make
                  filteredModels = ModelRepository.filterModels(newValue!);
                });
              },
              items: makers.map((Make options) {
                return DropdownMenuItem<String>(
                  value: options.name,
                  child: Text(
                    options.name,
                    style: const TextStyle(fontWeight: FontWeight.normal),
                  ),
                );
              }).toList(),
              validator: (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please select Manufacturer.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                label: const Text('Model *'),
                isDense: true,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              value: _selectedModel,
              // menuMaxHeight: 400,
              hint: const Text(
                'Select Model',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              borderRadius: BorderRadius.circular(8),
              onChanged: <String>(newValue) {
                setState(() {
                  _selectedModel = newValue;
                });
              },
              items: filteredModels.map((Model options) {
                return DropdownMenuItem<String>(
                  value: options.name,
                  child: Text(
                    options.name,
                    style: const TextStyle(fontWeight: FontWeight.normal),
                  ),
                );
              }).toList(),
              validator: (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please select Model.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: widget.vehicleItem?.variant,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                isDense: true,
                label: const Text('Variant Name'),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                hintText: 'Enter Variant name',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return null;
                }
                if (value.trim().isEmpty) {
                  return 'Variant should not consist of only spaces.';
                }

                return null;
              },
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState!.validate()) {
                  // Process data.
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                    'Vehicle ${(_isNewVehicle) ? 'created' : 'updated'}.',
                    textAlign: TextAlign.center,
                  )));
                }
              },
              icon: const Icon(Icons.inventory_rounded),
              label: Text('${(_isNewVehicle) ? 'Add a' : 'Update'} Vehicle'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
