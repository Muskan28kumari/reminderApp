import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'dart:async';

import 'package:reminderapp/reminderclass.dart';

class MyHomePage2 extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage2> {
  List<Reminder> reminders = [];

  void _addReminder(Reminder reminder) {
    setState(() {
      reminders.add(reminder);
    });

    Timer(reminder.dateTime.difference(DateTime.now()), () {
      showSimpleNotification(
        Text(reminder.title),
        subtitle: Text(reminder.description),
        background: Colors.blue,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User-Based Reminders'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Example: Schedule a reminder 5 seconds from now
                DateTime reminderTime =
                    DateTime.now().add(Duration(seconds: 5));
                _addReminder(Reminder(
                  title: 'Reminder Title',
                  description: 'This is a reminder description',
                  dateTime: reminderTime,
                ));
              },
              child: Text('Add Reminder'),
            ),
            ...reminders.map((reminder) => ListTile(
                  title: Text(reminder.title),
                  subtitle: Text(reminder.description),
                  trailing: Text(reminder.dateTime.toIso8601String()),
                )),
          ],
        ),
      ),
    );
  }
}
