import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotiScreen extends StatelessWidget {
  const NotiScreen({super.key});
  static const notificationRoute = "/notification-screen";

  @override
  Widget build(BuildContext context) {
    final msg = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification"),
      ),
      body: Center(
        child: Column(
          children: [
            Text(msg.notification?.title ?? ''),
            Text(msg.notification?.body ?? ''),
            Text(msg.data.toString()),
          ],
        ),
      ),
    );
  }
}
