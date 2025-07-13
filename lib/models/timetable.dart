class TimetableEntry {
  final String id;
  final String day;
  final String timeSlot;
  final String subject;
  final String room;
  final String teacher;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  TimetableEntry({
    required this.id,
    required this.day,
    required this.timeSlot,
    required this.subject,
    required this.room,
    required this.teacher,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'timeSlot': timeSlot,
      'subject': subject,
      'room': room,
      'teacher': teacher,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory TimetableEntry.fromMap(Map<String, dynamic> map, String id) {
    return TimetableEntry(
      id: id,
      day: map['day'] ?? '',
      timeSlot: map['timeSlot'] ?? '',
      subject: map['subject'] ?? '',
      room: map['room'] ?? '',
      teacher: map['teacher'] ?? '',
      description: map['description'],
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(map['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  TimetableEntry copyWith({
    String? id,
    String? day,
    String? timeSlot,
    String? subject,
    String? room,
    String? teacher,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TimetableEntry(
      id: id ?? this.id,
      day: day ?? this.day,
      timeSlot: timeSlot ?? this.timeSlot,
      subject: subject ?? this.subject,
      room: room ?? this.room,
      teacher: teacher ?? this.teacher,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 