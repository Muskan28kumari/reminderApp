import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('In-App Notifications'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showSimpleNotification(
              Text("This is a notification"),
              background: Colors.green,
            );
          },
          child: Text("Show Notification"),
        ),
      ),
    );
  }
}
