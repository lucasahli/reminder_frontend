import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/components/reminderContext/domain/entities/reminder.dart';
import '../../core/ports/inputPorts/get_reminders_of_current_user_use_case.dart';
// Import the DetailsScreen

class MyHomePage extends StatefulWidget {
  final GetRemindersOfCurrentUserUseCase _getRemindersOfCurrentUserUseCase;

  const MyHomePage(
      this._getRemindersOfCurrentUserUseCase,
      {Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Reminder?> _reminders = [];

  @override
  void initState() {
    super.initState();
    fetchReminders();
  }

  Future<void> fetchReminders() async {
    try {
      final newReminders = await widget._getRemindersOfCurrentUserUseCase.execute();
      setState(() {
        _reminders = newReminders;
      });
      print("fetched Reminders...");
    } catch (error) {
      print('Error fetching reminders: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reminders'),
      ),
      body: ListView.builder(
        itemCount: _reminders.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          final reminder = _reminders[index];
          if (reminder != null) {
            return ListTile(
              title: Text(reminder.title),
              subtitle: Text(reminder.id),
              trailing: Text(reminder.dateTimeToRemind?.toIso8601String() ?? ''),
              enabled: !reminder.isCompleted,

              onTap: () {
                context.goNamed("reminderDetail", pathParameters: {'reminderId': reminder.id});

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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print('Add Reminder...');
          final Reminder? result = await context.push<Reminder?>('/addReminder');
          if(result != null){
            _reminders.add(result);
            setState(() {
              _reminders = _reminders;
            });
            print("Added a reminder... ${result.title}");
            // fetchReminders();
          }
          else {
            print("Could not add a reminder...");
          }
        },
        child: const Icon(Icons.add), // You can use any icon you like
      ),
    );
  }
}
