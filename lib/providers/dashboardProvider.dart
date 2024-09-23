// lib/providers/dashboard_provider.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DashboardProvider extends ChangeNotifier {
  String userName = '';
  String userEmail = '';
  String userAadhar = '';
  String userPhone = '';
  String selectedBorrowOption = 'BORROW';
  String selectedLenderOption = 'LENDER';

  final List<String> borrowOptions = ['BORROW', 'Option 1', 'Option 2'];
  final List<String> lenderOptions = ['LENDER', 'Option 3', 'Option 4'];

  DashboardProvider() {
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser!;
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    userName = userDoc['name'];
    userEmail = userDoc['email'];
    userAadhar = userDoc['aadharNumber'];
    userPhone = userDoc['phone'];
    notifyListeners();
  }

  void setBorrowOption(String newOption) {
    selectedBorrowOption = newOption;
    notifyListeners();
  }

  void setLenderOption(String newOption) {
    selectedLenderOption = newOption;
    notifyListeners();
  }
}
