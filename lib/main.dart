import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:beam/bottom_navigation_bar/BottomNavBar.dart';
import 'package:beam/main_screens/blogs.dart';
import 'package:beam/main_screens/cancer_care.dart';
import 'package:beam/main_screens/health_screen.dart';
import 'package:beam/main_screens/profile.dart';
import 'package:beam/auth_screens/splash_screen.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui';
import 'package:beam/providers/user_provider.dart';
import 'package:beam/models/user_model.dart';
import 'package:provider/provider.dart';

import 'main_screens/search_blogs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBeZ8C4YWQ28ptbQmDGUdIX3FO4jAxpX-Q",
          authDomain: "beam-care.firebaseapp.com",
          projectId: "beam-care",
          storageBucket: "beam-care.appspot.com",
          messagingSenderId: "322061725199",
          appId: "1:322061725199:web:b8968e436d22695f713d7a"
      )
  );

  await Hive.initFlutter();
  runApp(ChangeNotifierProvider(
    create: (context) => UserModel(),
    child: MyApp(),
  ),);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      title: 'Beam',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      routes: {
        '/home': (context) => HomeScreen(),
        // Add other routes as needed
      },
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

class HomeScreen extends StatefulWidget {


  HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const CancerCare(),
      const Blogs(),
      const SearchBlogs(),
      const HealthScreen(),
      const Profile(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  bool get isMobile => (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS) && kIsWeb == false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _screens[_selectedIndex],
          Positioned(
            bottom: 70,
            left: 35,
            right: 35,
            child: BottomBar(
              currentIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
            ),
          ),
        ],
      ),
    );
  }
}
