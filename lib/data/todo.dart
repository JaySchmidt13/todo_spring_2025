import 'package:cloud_firestore/cloud_firestore.dart';

// class Todo {
//   final String id;
//   final String text;
//   final String uid;
//   final DateTime createdAt;
//   final DateTime? completedAt;
//   final DateTime? dueAt;
//   final String category;
//   final String? location;
//   final bool isCompleted;
//   final DateTime? completedDate;
//
//   Todo({
//     required this.id,
//     required this.text,
//     required this.uid,
//     required this.createdAt,
//     this.completedAt,
//     this.dueAt,
//     required this.category,
//     this.location,
//     this.isCompleted = false,
//     this.completedDate,
//   });
//
//   Map<String, dynamic> toSnapshot() {
//     return {
//       'text': text,
//       'uid': uid,
//       'createdAt': Timestamp.fromDate(createdAt),
//       'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
//       'dueAt': dueAt != null ? Timestamp.fromDate(dueAt!) : null,
//       'category': category,
//       'location': location,
//       'isCompleted': isCompleted,
//       'completedDate': completedDate != null ? Timestamp.fromDate(completedDate!) : null,
//     };
//   }
//
//   factory Todo.fromSnapshot(DocumentSnapshot snapshot) {
//     final data = snapshot.data() as Map<String, dynamic>;
//     return Todo(
//       id: snapshot.id,
//       text: data['text'] ?? '',
//       uid: data['uid'] ?? '',
//       createdAt: data['createdAt'] != null ? (data['createdAt'] as Timestamp).toDate() : DateTime.now(),
//       completedAt: data['completedAt'] != null ? (data['completedAt'] as Timestamp).toDate() : null,
//       dueAt: data['dueAt'] != null ? (data['dueAt'] as Timestamp).toDate() : null,
//       category: data['category'] ?? 'Default',
//       location: data['location'],
//       isCompleted: data['isCompleted'] ?? false,
//       completedDate: data['completedDate'] != null ? (data['completedDate'] as Timestamp).toDate() : null,
//     );
//   }
//
//   Todo copyWith({
//     String? id,
//     String? text,
//     String? uid,
//     DateTime? createdAt,
//     DateTime? completedAt,
//     DateTime? dueAt,
//     String? category,
//     String? location,
//     bool? isCompleted,
//     DateTime? completedDate,
//   }) {
//     return Todo(
//       id: id ?? this.id,
//       text: text ?? this.text,
//       uid: uid ?? this.uid,
//       createdAt: createdAt ?? this.createdAt,
//       completedAt: completedAt ?? this.completedAt,
//       dueAt: dueAt ?? this.dueAt,
//       category: category ?? this.category,
//       location: location ?? this.location,
//       isCompleted: isCompleted ?? this.isCompleted,
//       completedDate: completedDate ?? this.completedDate,
//     );
//   }
// }

class Todo {
  final String id;
  final String text;
  final String uid;
  final DateTime createdAt;
  final DateTime? completedAt;
  final DateTime? dueAt;
  final String category;
  final String? location;
  final bool isCompleted;
  final bool archived;
  final DateTime? archivedAt;

  Todo({
    required this.id,
    required this.text,
    required this.uid,
    required this.createdAt,
    this.completedAt,
    this.dueAt,
    required this.category,
    this.location,
    this.isCompleted = false,
    this.archived = false,
    this.archivedAt,
  });

  Map<String, dynamic> toSnapshot() {
    return {
      'text': text,
      'uid': uid,
      'createdAt': Timestamp.fromDate(createdAt),
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'dueAt': dueAt != null ? Timestamp.fromDate(dueAt!) : null,
      'category': category,
      'location': location,
      'isCompleted': isCompleted,
      'archived': archived,
      'archivedAt': archivedAt != null ? Timestamp.fromDate(archivedAt!) : null,
    };
  }

  factory Todo.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Todo(
      id: snapshot.id,
      text: data['text'] ?? '',
      uid: data['uid'] ?? '',
      createdAt: data['createdAt'] != null ? (data['createdAt'] as Timestamp).toDate() : DateTime.now(),
      completedAt: data['completedAt'] != null ? (data['completedAt'] as Timestamp).toDate() : null,
      dueAt: data['dueAt'] != null ? (data['dueAt'] as Timestamp).toDate() : null,
      category: data['category'] ?? 'Default',
      location: data['location'],
      isCompleted: data['isCompleted'] ?? false,
      archived: data['archived'] ?? false,
      archivedAt: data['archivedAt'] != null ? (data['archivedAt'] as Timestamp).toDate() : null,
    );
  }
}