import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'dart:async';

import 'package:reminderapp/reminderclass.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  List<Reminder> reminders = [];

  void _addReminder(Reminder reminder) {
    setState(() {
      reminders.add(reminder);
    });

    final Duration difference = reminder.dateTime.difference(DateTime.now());
    if (difference.isNegative) {
      print("Reminder time is in the past");
      return;
    }

    print(
        "Scheduling notification for: ${difference.inSeconds} seconds from now");
    Timer(difference, () {
      print("Showing notification: ${reminder.title}");
      showSimpleNotification(
        Text(reminder.title),
        subtitle: Text(reminder.description),
        background: Colors.blue,
      );
    });
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  String _formatTime(DateTime date) {
    return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade600,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade900,
        title: Text(
          'Reminder App',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final result = await showDialog<Reminder>(
                  context: context,
                  builder: (BuildContext context) {
                    return ReminderDialog();
                  },
                );

                if (result != null) {
                  _addReminder(result);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add),
                  Text('Add Reminder',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            ...reminders.map((reminder) => Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: ListTile(
                    title: Text(
                      reminder.title,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      reminder.description,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _formatDate(reminder.dateTime),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _formatTime(reminder.dateTime),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class ReminderDialog extends StatefulWidget {
  @override
  _ReminderDialogState createState() => _ReminderDialogState();
}

class _ReminderDialogState extends State<ReminderDialog> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  DateTime _dateTime = DateTime.now();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateController.text = _formatDate(_dateTime);
    _timeController.text = _formatTime(_dateTime);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  String _formatTime(DateTime date) {
    return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('New Reminder'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Title'),
              onSaved: (value) {
                _title = value!;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Description'),
              onSaved: (value) {
                _description = value!;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _dateController,
              decoration: InputDecoration(labelText: 'Date'),
              readOnly: true,
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _dateTime,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    _dateTime = DateTime(
                      picked.year,
                      picked.month,
                      picked.day,
                      _dateTime.hour,
                      _dateTime.minute,
                    );
                    _dateController.text = _formatDate(_dateTime);
                  });
                }
              },
            ),
            TextFormField(
              controller: _timeController,
              decoration: InputDecoration(labelText: 'Time'),
              readOnly: true,
              onTap: () async {
                TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(_dateTime),
                );
                if (picked != null) {
                  setState(() {
                    _dateTime = DateTime(
                      _dateTime.year,
                      _dateTime.month,
                      _dateTime.day,
                      picked.hour,
                      picked.minute,
                    );
                    _timeController.text =
                        _formatTime(_dateTime); // Use _formatTime method here
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Save'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              Navigator.of(context).pop(Reminder(
                title: _title,
                description: _description,
                dateTime: _dateTime,
              ));
            }
          },
        ),
      ],
    );
  }
}
