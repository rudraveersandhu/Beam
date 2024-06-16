/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchUserData(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (doc.exists) {
        _user = UserModel.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        _error = 'User not found';
      }
    } catch (e) {
      _error = 'Error fetching user data: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
*/