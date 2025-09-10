import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final CollectionReference noteRef = FirebaseFirestore.instance.collection("notes");

  Future<void> addNote(String title) {
    return noteRef.add({"title": title, 'timestamp': DateTime.now()});
  }

  Stream<QuerySnapshot> getNotes() {
    return noteRef.orderBy('timestamp', descending: true).snapshots();
  }

  Future<void> deleteNote(String docId) {
    return noteRef.doc(docId).delete();
  }

  Future<void> updateNote(String docId, String title) {
    return noteRef.doc(docId).update({'title': title, 'timestamp': Timestamp.now()});
  }
}