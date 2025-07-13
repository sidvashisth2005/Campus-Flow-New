import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/club.dart';

class ClubService {
  final CollectionReference clubs = FirebaseFirestore.instance.collection('clubs');

  Future<Club?> getClub(String id) async {
    final doc = await clubs.doc(id).get();
    if (doc.exists) {
      return Club.fromFirestore(doc);
    }
    return null;
  }

  Future<void> createClub(Club club) async {
    await clubs.doc(club.id).set(club.toMap());
  }

  Future<void> updateClub(String id, Map<String, dynamic> data) async {
    await clubs.doc(id).update(data);
  }

  Future<void> deleteClub(String id) async {
    await clubs.doc(id).delete();
  }

  Stream<List<Club>> clubListStream() {
    return clubs.snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => Club.fromFirestore(doc)).toList()
    );
  }
} 