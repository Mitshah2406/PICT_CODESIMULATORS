import 'dart:convert';

Task taskFromJson(String str) => Task.fromJson(json.decode(str));

String taskToJson(Task data) => json.encode(data.toJson());

class Task {
  String? id;
  String? taskTitle;
  String? taskDescription;
  int? taskPoints;

  Task({
    this.id,
    this.taskTitle,
    this.taskDescription,
    this.taskPoints,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["_id"],
        taskTitle: json["taskTitle"],
        taskDescription: json["taskDescription"],
        taskPoints: json["taskPoints"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "taskTitle": taskTitle,
        "taskDescription": taskDescription,
        "taskPoints": taskPoints,
      };
}
