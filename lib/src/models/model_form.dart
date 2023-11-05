import 'package:flutter/material.dart';

import '../model/model.dart';
import '../model/make.dart';
import '../data/make_repository.dart';

class ModelForm extends StatefulWidget {
  const ModelForm({super.key, this.modelItem});

  final Model? modelItem;

  @override
  State<ModelForm> createState() => _ModelFormState();
}

class _ModelFormState extends State<ModelForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String? _selectedMake;
  bool _isCreate = true;
  late List<Make> makers;

  @override
  void initState() {
    super.initState();
    if (widget.modelItem != null) {
      setState(() {
        _isCreate = false;
      });
    }
    _selectedMake = widget.modelItem?.make;

    makers = MakeRepository.loadAllMake();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
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
              onChanged: <String>(newValue) {
                // setState(() {
                //   _selectedMake = newValue;
                // });
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
            // FormField<String>(
            //   builder: (FormFieldState<String> state) {
            //     return InputDecorator(
            //       decoration: InputDecoration(
            //         label: const Text('Make *'),
            //         isDense: true,
            //         border: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(8)),
            //         hintText: 'Please select Manufacturer',
            //       ),
            //       child: DropdownButtonHideUnderline(
            //         child: DropdownButton<String>(
            //           value: _selectedMake,
            //           hint: const Text(
            //             'Select Manufacturer',
            //             style: TextStyle(fontWeight: FontWeight.normal),
            //           ),
            //           borderRadius: BorderRadius.circular(24),
            //           isDense: true,
            //           onChanged: <String>(newValue) {
            //             setState(() {
            //               _selectedMake = newValue;
            //               state.didChange(newValue);
            //             });
            //           },
            //           items: makers.map((Make options) {
            //             return DropdownMenuItem<String>(
            //               value: options.name,
            //               child: Text(
            //                 options.name,
            //                 style:
            //                     const TextStyle(fontWeight: FontWeight.normal),
            //               ),
            //             );
            //           }).toList(),
            //         ),
            //       ),
            //     );
            //   },
            // ),
            // const SizedBox(height: 16),
            TextFormField(
              // keyboardType: TextInputType.text,
              initialValue: widget.modelItem?.name,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                isDense: true,
                label: const Text('Model Name *'),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                hintText: 'Enter Model name',
              ),
              validator: (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter Model name.';
                }
                if (value.trim().length < 2) {
                  return 'Model should be atleast two characters long.';
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
                    'Model ${(_isCreate) ? 'created' : 'updated'}.',
                    textAlign: TextAlign.center,
                  )));
                }
              },
              icon: const Icon(Icons.inventory_rounded),
              label: Text('${(_isCreate) ? 'Add a' : 'Update'} Model'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
