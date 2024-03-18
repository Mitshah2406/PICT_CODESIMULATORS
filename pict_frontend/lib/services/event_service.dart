import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:pict_frontend/config/app_constants.dart';
import 'package:pict_frontend/models/Event.dart';

final eventServiceProvider = Provider<EventService>((ref) {
  return EventService();
});

class EventService {
  Future<List<Event>> getAllEvents() async {
    try {
      var response = await http.get(
        Uri.parse("${AppConstants.IP}/getAllEvents"),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      var result = jsonDecode(response.body)["result"];

      List<Event> events = [];

      for (var eventJson in result) {
        Event event = Event.fromJson(eventJson);
        events.add(event);
      }

      return events;
    } catch (e) {
      print(e);
      throw Exception('Failed to fetch events');
    }
  }

  Future<Event> getEventById(id) async {
    try {
      var response = await http.post(
        Uri.parse("${AppConstants.IP}/getSingleEventById"),
        body: jsonEncode({
          "eventId": id,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      var result = jsonDecode(response.body)["result"];
      Event event = Event.fromJson(result);

      return event;
    } catch (e) {
      print(e);
      throw Exception('Failed to fetch event page');
    }
  }
}
