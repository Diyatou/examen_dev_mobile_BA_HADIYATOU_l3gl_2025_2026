import 'package:flutter/material.dart';

enum TaskStatus { todo, inProgress, done }
enum TaskPriority { low, medium, high }

class Task {
  final String id;
  final String projectId;
  final String title;
  final String description;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime? dueDate;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.projectId,
    required this.title,
    this.description = '',
    this.status = TaskStatus.todo,
    this.priority = TaskPriority.medium,
    this.dueDate,
    required this.createdAt,
  });

  // Conversion pour le stockage (SharedPreferences)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'projectId': projectId,
      'title': title,
      'description': description,
      'status': status.index,
      'priority': priority.index,
      'dueDate': dueDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      projectId: map['projectId'],
      title: map['title'],
      description: map['description'] ?? '',
      status: TaskStatus.values[map['status']],
      priority: TaskPriority.values[map['priority']],
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}