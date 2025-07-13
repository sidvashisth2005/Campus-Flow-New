import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event.dart';

class EventService {
  final CollectionReference events = FirebaseFirestore.instance.collection('events');

  Future<Event?> getEvent(String id) async {
    final doc = await events.doc(id).get();
    if (doc.exists) {
      return Event.fromFirestore(doc);
    }
    return null;
  }

  Future<void> createEvent(Event event) async {
    await events.doc(event.id).set(event.toMap());
  }

  Future<void> updateEvent(String id, Map<String, dynamic> data) async {
    await events.doc(id).update(data);
  }

  Future<void> deleteEvent(String id) async {
    await events.doc(id).delete();
  }

  Stream<List<Event>> eventListStream() {
    return events.snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList()
    );
  }

  Stream<List<Event>> approvedEventListStream() {
    return events.where('isApproved', isEqualTo: true).snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList()
    );
  }
} 