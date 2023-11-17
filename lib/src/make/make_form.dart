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
                return null;
              },
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () async {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  // Process data.
                  final make = Make(
                      id: widget.makeItem?.id,
                      name: nameController.text.trim());

                  bool duplicateItem = false;

                  // Check if new value is creating duplicate of existing item
                  await makeService.checkDuplicate(make).then((snap) async {
                    // debugPrint('Size: ${snap.size}');
                    // debugPrint('Length: ${snap.docs.length}');
                    // debugPrint('isEmpty: ${snap.docs.isEmpty}');

                    if (snap.docs.isNotEmpty) {
                      duplicateItem = true;
                      _showDuplicateError(context, make);
                    }
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

                  // if not duplicate then proceed to create or update
                  if (!duplicateItem) {
                    if (_isCreate) {
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
                      // TODO(omkartapale): while update cross check if the updated name already exist with same ID then update or else show duplicate error
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

  Future<dynamic> _showDuplicateError(BuildContext context, Make make) {
    final ThemeData theme = Theme.of(context);
    final TextStyle textStyle = theme.textTheme.bodyMedium!;
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.error_outline_rounded, size: 48),
        iconColor: theme.colorScheme.onErrorContainer,
        backgroundColor: theme.colorScheme.errorContainer,
        title: const Text("Found Duplicate!"),
        content: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: 'Couldn\'t add this Make. Another manufacturer ',
                  style: textStyle),
              TextSpan(
                  text: make.name,
                  style: textStyle.copyWith(fontWeight: FontWeight.bold)),
              TextSpan(
                  text: ' already exists with the same details.',
                  style: textStyle),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: Text(
              'OK',
              style: textStyle,
            ),
          ),
        ],
      ),
    );
  }
}
