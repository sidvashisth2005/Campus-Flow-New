import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/timetable.dart';

class TimetableService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'timetable';

  // Get all timetable entries
  Stream<List<TimetableEntry>> getTimetableStream() {
    return _firestore
        .collection(_collection)
        .orderBy('day')
        .orderBy('timeSlot')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TimetableEntry.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Get timetable entries by day
  Stream<List<TimetableEntry>> getTimetableByDayStream(String day) {
    return _firestore
        .collection(_collection)
        .where('day', isEqualTo: day)
        .orderBy('timeSlot')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TimetableEntry.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Get a single timetable entry
  Future<TimetableEntry?> getTimetableEntry(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists) {
        return TimetableEntry.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('Error getting timetable entry: $e');
      return null;
    }
  }

  // Create a new timetable entry
  Future<void> createTimetableEntry(TimetableEntry entry) async {
    try {
      await _firestore.collection(_collection).add(entry.toMap());
    } catch (e) {
      print('Error creating timetable entry: $e');
      rethrow;
    }
  }

  // Update a timetable entry
  Future<void> updateTimetableEntry(TimetableEntry entry) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(entry.id)
          .update(entry.toMap());
    } catch (e) {
      print('Error updating timetable entry: $e');
      rethrow;
    }
  }

  // Delete a timetable entry
  Future<void> deleteTimetableEntry(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      print('Error deleting timetable entry: $e');
      rethrow;
    }
  }

  // Get all unique days
  Future<List<String>> getUniqueDays() async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .orderBy('day')
          .get();
      
      final days = snapshot.docs
          .map((doc) => doc.data()['day'] as String)
          .toSet()
          .toList();
      
      return days;
    } catch (e) {
      print('Error getting unique days: $e');
      return [];
    }
  }
} 