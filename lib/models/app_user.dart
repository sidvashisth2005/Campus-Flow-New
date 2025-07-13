import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String? phone;
  final String? bio;
  final String? role; // user, admin, club_leader
  final List<String>? clubIds;
  final List<String>? registeredEventIds;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.phone,
    this.bio,
    this.role,
    this.clubIds,
    this.registeredEventIds,
    this.createdAt,
    this.updatedAt,
  });

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'],
      phone: data['phone'],
      bio: data['bio'],
      role: data['role'],
      clubIds: List<String>.from(data['clubIds'] ?? []),
      registeredEventIds: List<String>.from(data['registeredEventIds'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'phone': phone,
      'bio': bio,
      'role': role,
      'clubIds': clubIds ?? [],
      'registeredEventIds': registeredEventIds ?? [],
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : FieldValue.serverTimestamp(),
    };
  }
} 