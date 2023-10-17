import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reminder_frontend/core/ports/inputPorts/create_reminder_use_case.dart';

class AddReminderScreen extends StatefulWidget {
  final CreateReminderUseCase _createReminderUseCase;

  const AddReminderScreen(
      this._createReminderUseCase,
      {Key? key}) : super(key: key);

@override
_AddReminderScreenState createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Reminder'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value ?? '';
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  _description = value ?? '';
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Add your logic to save the reminder
                    // For example, you can create a Reminder object and save it to a list or database.
                    // Then, navigate back to the previous screen.
                    // Example:
                    // final reminder = Reminder(
                    //   title: _title,
                    //   description: _description,
                    // );
                    // reminders.add(reminder);
                    DateTime dateTimeToRemind = DateTime.utc(2030);
                    // var result = await widget._createReminderUseCase.execute(_title, _dateTimeToRemind);
                    context.pop(widget._createReminderUseCase.execute(_title, dateTimeToRemind));
                  }
                },
                child: const Text('Save Reminder'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
