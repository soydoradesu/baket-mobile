// lib/features/user/dialogs/edit_dialogs.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<String?> showSingleFieldDialog(
  BuildContext context, {
  required String title,
  String initialValue = '',
  TextInputType inputType = TextInputType.text,
}) async {
  final controller = TextEditingController(text: initialValue);
  return showDialog<String>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text('Update $title'),
      content: TextField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(labelText: title),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, controller.text),
          child: const Text('Update'),
        ),
      ],
    ),
  );
}

Future<Map<String, String>?> showNameDialog(
  BuildContext context, {
  required String currentFirst,
  required String currentLast,
}) async {
  final firstNameController = TextEditingController(text: currentFirst);
  final lastNameController = TextEditingController(text: currentLast);

  return showDialog<Map<String, String>>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Update Name'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: firstNameController, decoration: const InputDecoration(labelText: 'First Name')),
          TextField(controller: lastNameController, decoration: const InputDecoration(labelText: 'Last Name')),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, {
            'first_name': firstNameController.text,
            'last_name': lastNameController.text,
          }),
          child: const Text('Update'),
        ),
      ],
    ),
  );
}

Future<DateTime?> showDatePickerDialog(BuildContext context, DateTime currentDate) async {
  return showDatePicker(
    context: context,
    initialDate: currentDate,
    firstDate: DateTime(1900),
    lastDate: DateTime.now(),
  );
}

Future<String?> showGenderDialog(BuildContext context, String currentGender) async {
  final genders = ['Male', 'Female', 'Other'];
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: const Text('Select Gender'),
        children: genders.map((gender) {
          return SimpleDialogOption(
            onPressed: () => Navigator.pop(context, gender),
            child: Text(gender),
          );
        }).toList(),
      );
    },
  );
}
