import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:reminderapp/reminderscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const OverlaySupport.global(
      child: MaterialApp(
          debugShowCheckedModeBanner: false, home: ReminderScreen()),
    );
  }
}
