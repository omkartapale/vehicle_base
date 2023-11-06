import 'package:flutter/material.dart';

import '../model/make.dart';

class MakeForm extends StatefulWidget {
  const MakeForm({super.key, this.makeItem});

  final Make? makeItem;

  @override
  State<MakeForm> createState() => _MakeFormState();
}

class _MakeFormState extends State<MakeForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isCreate = true;

  @override
  void initState() {
    super.initState();
    if (widget.makeItem != null) {
      setState(() {
        _isCreate = false;
      });
    }
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
            TextFormField(
              // keyboardType: TextInputType.text,
              initialValue: widget.makeItem?.name,
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
                    'Manufacturer ${(_isCreate) ? 'created' : 'updated'}.',
                    textAlign: TextAlign.center,
                  )));
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
