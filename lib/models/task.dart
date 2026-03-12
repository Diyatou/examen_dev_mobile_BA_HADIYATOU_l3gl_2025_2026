import 'package:flutter/material.dart';

class Task {
  final String id;
  final String projectId;
  final String userId;
  String title;
  String description;
  String status; // 'À faire', 'En cours', 'Terminée'
  String priority; // 'Haute', 'Moyenne', 'Basse'
  DateTime dueDate;

  Task({
    required this.id,
    required this.projectId,
    required this.userId,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.dueDate,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      projectId: json['projectId'],
      userId: json['userId'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      priority: json['priority'],
      dueDate: DateTime.parse(json['dueDate']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'projectId': projectId,
    'userId': userId,
    'title': title,
    'description': description,
    'status': status,
    'priority': priority,
    'dueDate': dueDate.toIso8601String(),
  };
}