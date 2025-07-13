import 'package:cloud_firestore/cloud_firestore.dart';

class Club {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final String? bannerUrl;
  final String? category;
  final List<String>? memberIds;
  final List<String>? eventIds;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Club({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    this.bannerUrl,
    this.category,
    this.memberIds,
    this.eventIds,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Club.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Club(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'],
      bannerUrl: data['bannerUrl'],
      category: data['category'],
      memberIds: List<String>.from(data['memberIds'] ?? []),
      eventIds: List<String>.from(data['eventIds'] ?? []),
      createdBy: data['createdBy'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'bannerUrl': bannerUrl,
      'category': category,
      'memberIds': memberIds ?? [],
      'eventIds': eventIds ?? [],
      'createdBy': createdBy,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : FieldValue.serverTimestamp(),
    };
  }
} 