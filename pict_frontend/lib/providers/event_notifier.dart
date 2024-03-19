import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pict_frontend/models/Event.dart';
import 'package:pict_frontend/services/event_service.dart';

final getAllEvents = FutureProvider<List<Event>>((ref) async {
  final eventService = ref.watch(eventServiceProvider);
  return await eventService.getAllEvents();
});

final getEventById = FutureProvider.family<Event, String>((ref, id) async {
  final eventService = ref.watch(eventServiceProvider);
  return await eventService.getEventById(id);
});

final getAllUpcomingEvents = FutureProvider<List<Event>>((ref) async {
  final eventService = ref.watch(eventServiceProvider);
  return await eventService.getAllUpcomingEvents();
});

final getAllOngoingEvents = FutureProvider<List<Event>>((ref) async {
  final eventService = ref.watch(eventServiceProvider);
  return await eventService.getAllOngoingEvents();
});

final getUserRegisteredEvents =
    FutureProvider.family<List<Event>, String>((ref, id) async {
  final eventService = ref.watch(eventServiceProvider);
  return await eventService.getUserRegisteredEvents(id);
});

final getUserCompletedEvents =
    FutureProvider.family<List<Event>, String>((ref, id) async {
  final eventService = ref.watch(eventServiceProvider);
  return await eventService.getUserCompletedEvents(id);
});

final getOngoingEventsByEmail =
    FutureProvider.family<List<Event>, String>((ref, email) async {
  final eventService = ref.watch(eventServiceProvider);
  return await eventService.getOngoingEventsByEmail(email);
});

// final checkIfUserAlreadyRegistered =
//     FutureProvider.family<bool, List<String>>((ref, id) async {
//   final eventService = ref.watch(eventServiceProvider);
//   print("Check UserId, EventId");
//   String userId = id[0];
//   String eventId = id[1];
//   print(userId + " " + eventId);
//   return await eventService.checkIfUserAlreadyRegistered(userId, eventId);
// });








// final generateCertificate =
//     FutureProvider.family<String, List<String>>((ref, id) async {
//   final eventService = ref.watch(eventServiceProvider);
//   print("Check UserId, EventId");
//   String userId = id[0];
//   String eventId = id[1];
//   // print(id.map((e) => print(e)));
//   return await eventService.generateCertificate(userId, eventId);
// });
