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
