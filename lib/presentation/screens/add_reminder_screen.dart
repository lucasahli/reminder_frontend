import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:reminder_frontend/core/ports/inputPorts/create_reminder_use_case.dart';

class AddReminderScreen extends StatefulWidget {
  final CreateReminderUseCase _createReminderUseCase;

  const AddReminderScreen(this._createReminderUseCase, {Key? key})
      : super(key: key);

  @override
  _AddReminderScreenState createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  final String _description = '';
  DateTime _dateTime = DateTime.now().add(const Duration(
      days: 0,
      hours: 0,
      minutes: 15,
      seconds: 0,
      milliseconds: 0,
      microseconds: 0));

  void _showDateThenTimePicker() {
    showDatePicker(
            context: context,
            initialDate: _dateTime,
            firstDate: DateTime.now(),
            lastDate: DateTime(2050))
        .then((dateValue) => {
              showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(_dateTime))
                  .then((timeValue) => {
                        setState(() {
                          if (dateValue != null && timeValue != null) {
                            _dateTime = DateTime(
                                dateValue.year,
                                dateValue.month,
                                dateValue.day,
                                timeValue.hour,
                                timeValue.minute,
                                0,
                                0,
                                0);
                          }
                        })
                      })
            });
  }

  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: _dateTime,
            firstDate: DateTime.now(),
            lastDate: DateTime(2050))
        .then((dateValue) => {
              setState(() {
                if (dateValue != null) {
                  _dateTime = DateTime(dateValue.year, dateValue.month,
                      dateValue.day, _dateTime.hour, _dateTime.minute, 0, 0, 0);
                }
              })
            });
  }

  void _showTimePicker() {
    showTimePicker(
            context: context, initialTime: TimeOfDay.fromDateTime(_dateTime))
        .then((timeValue) => {
              setState(() {
                if (timeValue != null) {
                  _dateTime = DateTime(_dateTime.year, _dateTime.month,
                      _dateTime.day, timeValue.hour, timeValue.minute, 0, 0, 0);
                }
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminder'),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: FilledButton.tonal(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  DateTime dateTimeToRemind = _dateTime.toUtc();
                  context.pop(widget._createReminderUseCase
                      .execute(_title, dateTimeToRemind));
                }
              },
              child: const Text('Save'),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              ListTile(
                title: TextFormField(
                  // initialValue: 'Add title',
                  decoration:
                      const InputDecoration.collapsed(hintText: 'Add title'),
                  // decoration: const InputDecoration(
                  //     labelText: 'Add title',
                  //     labelStyle: TextStyle(fontSize: 24.0),
                  //     floatingLabelBehavior: FloatingLabelBehavior.never),
                  validator: (value) {
                    if (value == null) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _title = value ?? '';
                  },
                  style: const TextStyle(fontSize: 24),
                  autofocus: true,
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.edit_calendar),
                title: TextButton(
                    onPressed: _showDatePicker,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        DateFormat.yMMMd('en_US').format(_dateTime),
                      ),
                    )),
                trailing: TextButton(
                  onPressed: _showTimePicker,
                  child: Text(DateFormat('Hm', 'en_US').format(_dateTime),
                      style: const TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
