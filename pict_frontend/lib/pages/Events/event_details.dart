import 'package:flutter/material.dart';
import 'package:pict_frontend/models/Event.dart';

class EventDetailsPage extends StatefulWidget {
  const EventDetailsPage({super.key, required this.event});
  final Event event;

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final Event event = widget.event;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(event.eventName!),
      ),
    );
  }
}
