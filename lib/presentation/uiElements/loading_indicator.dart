import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 50, // Set the width
        height: 50, // Set the height
        child: CircularProgressIndicator(
          valueColor:
              AlwaysStoppedAnimation<Color>(Colors.blue), // Set the color
          strokeWidth: 5, // Set the stroke width
        ),
      ),
    );
  }
}
