import 'package:flutter/material.dart';
import 'package:reminder_frontend/reminder_theme.dart';
import 'screens/home.dart';
import 'screens/signup.dart'; // Import the SignUpScreen
import 'screens/signin.dart'; // Import the SignInScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reminder',
      theme: reminderTheme,
      initialRoute: '/signin', // Set the initial route to the sign-in screen
      routes: {
        '/signin': (context) => SignInScreen(), // Define the sign-in screen route
        '/signup': (context) => SignUpScreen(), // Define the sign-up screen route
        '/home': (context) => MyHomePage(), // Define the home screen route
      },
    );
  }
}