import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final ThemeData reminderTheme = ThemeData(
  primaryColor: const Color(0xFF6200EE), // Customize your primary color
  hintColor: const Color(0xFFFFD600), // Customize your accent color
  scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Customize background color
  fontFamily: 'Roboto', // Choose your desired font family

  // Define text styles for various parts of your app
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black),
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
    bodyLarge: TextStyle(fontSize: 16, color: Colors.black),
    labelLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
  ),

  // Define the button theme
  buttonTheme: ButtonThemeData(
    buttonColor: const Color(0xFF6200EE), // Customize button color
    textTheme: ButtonTextTheme.primary,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),

  // Define the input decoration for text fields
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFF6200EE), width: 2),
    ),
    contentPadding: const EdgeInsets.all(16),
  ),

  // Customize the app bar theme
  appBarTheme: const AppBarTheme(
    color: Color(0xFF6200EE), // Customize status bar brightness
    titleTextStyle:TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    iconTheme: IconThemeData(color: Colors.white), systemOverlayStyle: SystemUiOverlayStyle.light, // Customize app bar icons
  ),

  // Customize the bottom app bar theme (if applicable)
  bottomAppBarTheme: const BottomAppBarTheme(
    color: Color(0xFF6200EE),
  ),

  // Customize the floating action button (FAB) theme (if applicable)
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF6200EE),
  ),

  // Customize the tab bar theme (if applicable)
  tabBarTheme: const TabBarTheme(
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(width: 2, color: Color(0xFF6200EE)),
      insets: EdgeInsets.symmetric(horizontal: 20),
    ),
  ),
);
