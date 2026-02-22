import 'package:flutter/material.dart';

class Project {
  final String id;
  final String name;
  final String description;
  final Color color;
  final DateTime createdAt;
  final String userId;

  Project({
    required this.id,
    required this.name,
    this.description = '',
    required this.color,
    required this.createdAt,
    required this.userId,
  });

  // Pour transformer le projet en format lisible par SharedPreferences (JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'color': color.value, // On stocke la valeur entière de la couleur
      'createdAt': createdAt.toIso8601String(),
      'userId': userId,
    };
  }

  // Pour créer un objet Project à partir des données stockées
  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'],
      name: map['name'],
      description: map['description'] ?? '',
      color: Color(map['color']),
      createdAt: DateTime.parse(map['createdAt']),
      userId: map['userId'],
    );
  }
}