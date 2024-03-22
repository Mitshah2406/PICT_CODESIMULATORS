import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:pict_frontend/models/Event.dart';
import 'package:pict_frontend/utils/constants/app_constants.dart';

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
      print("Result");
      print(result);

      List<Event> events = [];

      for (var eventJson in result) {
        Event event = Event.fromJson(eventJson);
        print(event);
        events.add(event);
      }

      return events;
    } catch (e) {
      print("Error de");
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

  Future<List<Event>> getAllUpcomingEvents() async {
    try {
      var response = await http.get(
        Uri.parse("${AppConstants.IP}/getAllUpcomingEvents"),
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
      throw Exception('Failed to fetch Upcoming Events');
    }
  }

  Future<List<Event>> getAllOngoingEvents() async {
    try {
      var response = await http.get(
        Uri.parse("${AppConstants.IP}/getAllOngoingEvents"),
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
      throw Exception('Failed to fetch Ongoing Events');
    }
  }

  Future<List<Event>> getUserRegisteredEvents(id) async {
    try {
      var response = await http.post(
        Uri.parse("${AppConstants.IP}/getUserRegisteredEvents"),
        body: jsonEncode({
          "userId": id,
        }),
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
      throw Exception('Failed to fetch Registered Events');
    }
  }

  Future<List<Event>> getUserCompletedEvents(id) async {
    try {
      var response = await http.post(
        Uri.parse("${AppConstants.IP}/getUserCompletedEvents"),
        body: jsonEncode({
          "userId": id,
        }),
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
      throw Exception('Failed to fetch Registered Events');
    }
  }

  static Future<String> generateCertificate(userId, eventId) async {
    try {
      var response = await http.post(
        Uri.parse("${AppConstants.IP}/generateCertificate"),
        body: jsonEncode({
          "userId": userId,
          "eventId": eventId,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      // print(response.body);
      var result = jsonDecode(response.body)["name"];

      return result;
    } catch (e) {
      print(e);
      throw Exception('Failed to Generate Certificate');
    }
  }

  static Future<bool> checkIfUserAlreadyRegistered(userId, eventId) async {
    try {
      var response = await http.post(
        Uri.parse("${AppConstants.IP}/checkIfAlreadyRegistered"),
        body: jsonEncode({
          "userId": userId,
          "eventId": eventId,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      // print(response.body);
      bool result = jsonDecode(response.body)["data"];
      // print(result);

      return result;
    } catch (e) {
      print(e);
      throw Exception('Failed to fetch');
    }
  }

  static Future<String> registerEvent(userId, eventId, registeringAs) async {
    try {
      var response = await http.post(
        Uri.parse("${AppConstants.IP}/registerEvent"),
        body: jsonEncode({
          "userId": userId,
          "eventId": eventId,
          "registeringAs": registeringAs,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      // print(response.body);
      String result = jsonDecode(response.body)["result"];
      // print(result);

      return result;
    } catch (e) {
      print(e);
      throw Exception('Failed to fetch');
    }
  }

  Future<List<Event>> getOngoingEventsByEmail(email) async {
    try {
      var response = await http.post(
        Uri.parse("${AppConstants.IP}/getOngoingEventsByEmail"),
        body: jsonEncode({
          "organizerEmail": email,
        }),
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
      throw Exception('Failed to Fetch ongoing events');
    }
  }

  static Future<String> markPresent(userId, eventId) async {
    try {
      var response = await http.post(
        Uri.parse("${AppConstants.IP}/markPresent"),
        body: jsonEncode({
          "userId": userId,
          "eventId": eventId,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      var result = jsonDecode(response.body)["message"];
      print(result);

      return result;
    } catch (e) {
      print(e);
      throw Exception('Failed to Fetch ongoing events');
    }
  }
}
