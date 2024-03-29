import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:pict_frontend/models/Task.dart';
import 'package:pict_frontend/utils/constants/app_constants.dart';

final taskServiceProvider = Provider<TaskServices>((ref) {
  return TaskServices();
});

class TaskServices {
  static Future<List<Task>> getRandomTask() async {
    try {
      var response = await http.get(
        Uri.parse(
          "${AppConstants.IP}/task/getRandomTask",
        ),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      var result = jsonDecode(response.body)["result"];

      List<Task> tasks = [];

      for (var taskJson in result) {
        Task task = Task.fromJson(taskJson);
        tasks.add(task);
      }

      return tasks;
    } catch (e) {
      print(e);
      throw Exception("Failed to failed to get the random task");
    }
  }

  static Future<bool> validateTask(
      String title, String imagePath, String userId, String taskId) async {
    try {
      print(title + " " + imagePath + " " + userId);
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${AppConstants.IP}/task/validateTask"),
      );

      request.fields
          .addAll({"userId": userId, "title": title, "taskId": taskId});

      request.files.add(
        await http.MultipartFile.fromPath(
          'imagePath',
          imagePath,
        ),
      );

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      print(responseData);

      var result = jsonDecode(responseData)["result"];

      return result;
    } catch (e) {
      print("Error occurred: $e");
      throw Exception("Failed to Add report");
    }
  }
}