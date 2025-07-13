import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String? bannerUrl;
  final String location;
  final DateTime startTime;
  final DateTime endTime;
  final String clubId;
  final List<String>? tags;
  final List<String>? attendeeIds;
  final int? capacity;
  final bool? isApproved;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Event({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    this.bannerUrl,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.clubId,
    this.tags,
    this.attendeeIds,
    this.capacity,
    this.isApproved,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Event.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Event(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'],
      bannerUrl: data['bannerUrl'],
      location: data['location'] ?? '',
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: (data['endTime'] as Timestamp).toDate(),
      clubId: data['clubId'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      attendeeIds: List<String>.from(data['attendeeIds'] ?? []),
      capacity: data['capacity'],
      isApproved: data['isApproved'],
      createdBy: data['createdBy'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'bannerUrl': bannerUrl,
      'location': location,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'clubId': clubId,
      'tags': tags ?? [],
      'attendeeIds': attendeeIds ?? [],
      'capacity': capacity,
      'isApproved': isApproved,
      'createdBy': createdBy,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : FieldValue.serverTimestamp(),
    };
  }
} 