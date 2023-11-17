import 'package:flutter/material.dart';

import '../model/make.dart';
import '../services/make_service.dart';

MakeService makeService = MakeService();

class MakeForm extends StatefulWidget {
  const MakeForm({super.key, this.makeItem});

  final Make? makeItem;

  @override
  State<MakeForm> createState() => _MakeFormState();
}

class _MakeFormState extends State<MakeForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();

  bool _isCreate = true;
  bool _duplicateItemFound = false;

  @override
  void initState() {
    super.initState();
    if (widget.makeItem != null) {
      nameController.text = widget.makeItem!.name;
      setState(() {
        _isCreate = false;
      });
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
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
            TextFormField(
              // keyboardType: TextInputType.text,
              // initialValue: nameController.text,
              controller: nameController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                isDense: true,
                label: const Text('Manufacturer Name *'),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                hintText: 'Enter Make name',
              ),
              validator: (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter Manufacturer / Make name.';
                }
                if (value.trim().length < 2) {
                  return 'Make should be atleast two characters long.';
                }
                if (_duplicateItemFound) {
                  return "Manufacturer with the same name already exists.";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () async {
                // Prepare object with new data for processing
                final make = Make(
                    id: widget.makeItem?.id,
                    name: nameController.text.trim(),
                    lowercasedName: nameController.text.trim().toLowerCase());

                // Check if new value is creating duplicate of existing item
                await makeService.checkDuplicate(make).then((snap) async {
                  // debugPrint('Size: ${snap.size}');
                  // debugPrint('Length: ${snap.docs.length}');
                  // debugPrint('isEmpty: ${snap.docs.isEmpty}');
                  _duplicateItemFound = snap.docs.isNotEmpty;
                }).catchError((e) {
                  debugPrint(e.toString());
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Error: Something went wrong. Try again.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                });

                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  // Process data.
                  // if form is valid and does not duplicate then proceed
                  // to create or update logic
                  if (_isCreate) {
                    // debugPrint('Validated and Adding new make');
                    await makeService.addMake(make).then((value) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Manufacturer ${make.name} created.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }).catchError((e) {
                      debugPrint(e.toString());
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Error: Something went wrong. Try again.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    });
                  } else {
                    debugPrint('Validated and Updating existing make');
                    await makeService.updateMake(make).then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Manufacturer ${widget.makeItem?.name} updated.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                      Navigator.pop(context);
                    }).catchError((e) {
                      debugPrint(e.toString());
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Error: Something went wrong. Try again.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    });
                  }
                }
              },
              icon: const Icon(Icons.inventory_rounded),
              label: (_isCreate)
                  ? const Text('Add a Make')
                  : const Text('Update Make'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
