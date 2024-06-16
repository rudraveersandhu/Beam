import 'package:beam/main.dart';
import 'package:beam/models/user_model.dart';
import 'package:beam/auth_screens/start_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen> {



  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  counterIncrement() async {
    final counterDoc = FirebaseFirestore.instance.collection('visits').doc('counter');

    // Check if the document exists
    final counterDocSnapshot = await counterDoc.get();
    if (counterDocSnapshot.exists) {
      // Document exists, update the count
      int x = counterDocSnapshot['count'] ?? 0; // Assuming 'count' is an integer
      await counterDoc.set({'count': x + 1});
    } else {
      // Document doesn't exist, create it with initial count value
      await counterDoc.set({'count': 1});
    }
  }

  void _checkAuth() async {
    await Future.delayed(Duration(seconds: 3));
    final model = context.read<UserModel>();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {

      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      model.id = userData['id'];
      model.name = userData['name'];
      model.profilePicture = userData['profile_pic'];
      model.email = userData['email'];
      model.pass = userData['password'];
      model.number = userData['phone'];
      model.blogs = userData['blogs'];
      model.joinedOn = userData['joined_on'];

      await counterIncrement();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => StartScreen()),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade300.withAlpha(1000),
      extendBody: true,
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/splash_image.jpg'),
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ),
    );
  }
}
