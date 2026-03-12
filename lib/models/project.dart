import 'package:flutter/material.dart';

class Project {
  final String id;
  final String name;
  final String description;
  final Color color;
  final DateTime createdAt;

  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.createdAt,
  });

  // Pour transformer le JSON en Objet Project
  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      color: Color(json['color']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // Pour transformer l'Objet Project en JSON (pour SharedPreferences)
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'color': color.value,
    'createdAt': createdAt.toIso8601String(),
  };
}