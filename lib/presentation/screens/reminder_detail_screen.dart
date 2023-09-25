import 'package:flutter/material.dart';
import '../../core/components/reminderContext/domain/entities/reminder.dart';
import '../../core/components/reminderContext/domain/entities/user.dart';
import '../../core/ports/inputPorts/get_reminder_details_use_case.dart';

class ReminderDetailScreen extends StatefulWidget {
  final String reminderId; // You can pass the ID of the reminder to fetch
  final GetReminderDetailsUseCase _getReminderDetailsUseCase;

  ReminderDetailScreen(this._getReminderDetailsUseCase, this.reminderId, {super.key});

  @override
  _ReminderDetailScreenState createState() => _ReminderDetailScreenState();
}

class _ReminderDetailScreenState extends State<ReminderDetailScreen> {
  late String reminderId;
  late Reminder? _reminder; // This will hold the fetched reminder details

  @override
  void initState() {
    super.initState();
    // Initialize the reminder ID from the widget's parameter
    reminderId = widget.reminderId;

    // Load the reminder details when the screen is created
    loadReminderDetails();
  }

  Future<void> loadReminderDetails() async {
    try {
      // Call the GetReminderDetailsUseCase to fetch the details
      final details = await widget._getReminderDetailsUseCase.execute(reminderId);

      setState(() {
        _reminder = details; // Update the state with the fetched details
      });
    } catch (e) {
      // Handle any errors that may occur during fetching
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminder Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if(_reminder != null)
              Text(
                'Title: ${_reminder!.title}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            SizedBox(height: 10),
            if(_reminder != null)
              Text('ID: ${_reminder!.id}'),
            SizedBox(height: 10),
            if(_reminder != null)
              Text('Is Completed: ${_reminder!.isCompleted ? 'Yes' : 'No'}'),
            SizedBox(height: 10),
            if(_reminder != null)
              if (_reminder!.dateTimeToRemind != null)
                Text('Date and Time to Remind: ${_reminder!.dateTimeToRemind}'),
            SizedBox(height: 10),
            if(_reminder != null)
              if (_reminder!.owner != null)
                Text('Owner: ${_reminder!.owner!.fullName}'), // Assuming 'name' is a property of the User class
            SizedBox(height: 10),
            if(_reminder != null)
              if (_reminder!.usersToRemind != null)
                Text('Users to Remind: ${_getUserNames(_reminder!.usersToRemind)}'),
          ],
        ),
      ),
    );
  }

  String _getUserNames(List<User>? users) {
    if (users == null || users.isEmpty) {
      return 'None';
    }
    return users.map((user) => user.fullName).join(', ');
  }

}

