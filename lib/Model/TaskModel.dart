
import 'package:cloud_firestore/cloud_firestore.dart';

enum TaskPriority { low, medium, high }

class Task {
  String? id; // Firestore document ID
  String title;
  String description;
  DateTime dueDate;
  TaskPriority priority;
  bool isCompleted;
  String userId; // To link tasks to specific users
  List<String> tags; // New field for tags

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    this.isCompleted = false,
    required this.userId,
    this.tags = const [], // Initialize with empty list
  });

  // Factory constructor to create a Task from a Firestore document
  factory Task.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Task(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      dueDate: (data['dueDate'] as Timestamp).toDate(),
      priority: TaskPriority.values.firstWhere(
            (e) => e.toString() == 'TaskPriority.${data['priority']}',
        orElse: () => TaskPriority.medium, // Default if not found
      ),
      isCompleted: data['isCompleted'] ?? false,
      userId: data['userId'] ?? '',
      tags: List<String>.from(data['tags'] ?? []), // Read tags
    );
  }

  // Convert Task object to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'dueDate': Timestamp.fromDate(dueDate),
      'priority': priority.toString().split('.').last, // Store as string
      'isCompleted': isCompleted,
      'userId': userId,
      'tags': tags, // Store tags
    };
  }

Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskPriority? priority,
    bool? isCompleted,
    String? userId,
    List<String>? tags,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      userId: userId ?? this.userId,
      tags: tags ?? this.tags, // Handle tags
    );}

  }