import 'package:flutter/material.dart';
import '../../core/components/reminderContext/domain/entities/reminder.dart';
import '../../core/ports/inputPorts/get_reminders_of_current_user_use_case.dart';
import 'details.dart'; // Import the DetailsScreen

class MyHomePage extends StatefulWidget {
  final GetRemindersOfCurrentUserUseCase _getRemindersOfCurrentUserUseCase;

  MyHomePage(this._getRemindersOfCurrentUserUseCase, {Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Reminder?>? reminders = [];

  @override
  void initState() {
    super.initState();
    fetchReminders();
  }

  Future<void> fetchReminders() async {
    try {
      reminders = await widget._getRemindersOfCurrentUserUseCase.execute();
      setState(() {}); // Trigger a rebuild of the widget
    } catch (error) {
      print('Error fetching reminders: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Reminders'),
      ),
      body: ListView.builder(
        itemCount: reminders?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          final reminder = reminders?[index];
          if (reminder != null) {
            return ListTile(
              title: Text(reminder.title),
              subtitle: Text(reminder.id),
              onTap: () {
                // Navigate to the Details screen when a post is tapped
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => DetailsScreen(post: reminder),
                //   ),
                // );
              },
            );
          }
          else {
            return const SizedBox(); // Placeholder for null reminders
          }
        },
      ),
    );
  }
}
