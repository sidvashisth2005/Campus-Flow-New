import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationItem {
  final String id;
  final String type; // e.g., event_update, club_announcement, reminder
  final String message;
  final String? userId;
  final String? eventId;
  final String? clubId;
  final DateTime timestamp;
  final bool read;

  NotificationItem({
    required this.id,
    required this.type,
    required this.message,
    this.userId,
    this.eventId,
    this.clubId,
    required this.timestamp,
    this.read = false,
  });

  factory NotificationItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationItem(
      id: doc.id,
      type: data['type'] ?? '',
      message: data['message'] ?? '',
      userId: data['userId'],
      eventId: data['eventId'],
      clubId: data['clubId'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      read: data['read'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'message': message,
      'userId': userId,
      'eventId': eventId,
      'clubId': clubId,
      'timestamp': Timestamp.fromDate(timestamp),
      'read': read,
    };
  }
} 