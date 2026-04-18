import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

Task taskFromJson(String str) => Task.fromJson(json.decode(str));

String taskToJson(Task data) => json.encode(data.toJson());

class Task {
    String id;
    String title;
    String description;
    DateTime createdAt;

    Task({
        required this.id,
        required this.title,
        required this.description,
        required this.createdAt,
    });

    factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        createdAt: DateTime.parse(json["createdAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "createdAt": createdAt.toIso8601String(),
    };

      factory Task.fromFirestore(Map<String, dynamic> data, String id) => Task(
        id: id,
        title: data["title"],
        description: data["description"],
        createdAt: (data["createdAt"] as Timestamp).toDate(),
      );

  Map<String, dynamic> toFirestore() => {
        "title": title,
        "description": description,
        "createdAt": createdAt,
      };
}
