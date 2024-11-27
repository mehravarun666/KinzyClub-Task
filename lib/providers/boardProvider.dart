import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BoardProvider with ChangeNotifier {
  List<Map<String, dynamic>> _lists = [];

  List<Map<String, dynamic>> get lists => _lists;

  Future<void> fetchLists(String boardId) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    try {
      final listCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('boards')
          .doc(boardId)
          .collection('lists');

      final snapshot = await listCollection.get();

      // Fetch cards for each list
      _lists = await Future.wait(snapshot.docs.map((doc) async {
        final data = doc.data();
        final cardCollection = await doc.reference.collection('cards').get();
        final cards = cardCollection.docs.map((cardDoc) {
          final cardData = cardDoc.data();
          cardData['id'] = cardDoc.id; // Include the card ID
          return cardData;
        }).toList();
        data['id'] = doc.id; // Include list ID
        data['cards'] = cards; // Add cards to the list
        return data;
      }).toList());


      notifyListeners();
    } catch (error) {
      print("Failed to fetch lists: $error");
    }
  }
}
