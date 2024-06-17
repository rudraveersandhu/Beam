import 'package:beam/auth_screens/sign_in_with_email.dart';
import 'package:beam/auth_screens/sign_up.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    double screen_width = MediaQuery.of(context).size.width;
    double maxScreenWidth = screen_width > 500 ? 500 : screen_width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              width: maxScreenWidth,
              child: Column(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        width: screen_width,
                        height: MediaQuery.of(context).size.height,
                        child: Image.asset('assets/signinbg.JPG', fit: BoxFit.cover),
                      ),
                      Container(
                        width: maxScreenWidth,
                        height: MediaQuery.of(context).size.height,
                        color: Colors.pink.withOpacity(0.70),
                      ),
                      Container(
                        width: maxScreenWidth,
                        height: MediaQuery.of(context).size.height,
                        color: Colors.white.withOpacity(0.50),
                      ),
                      Container(
                        width: maxScreenWidth,
                        height: MediaQuery.of(context).size.height,
                        color: Colors.pink.withOpacity(0.45),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SafeArea(child: Text('')),
                              Text(
                                'B e a m',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 70,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 30),
                              Container(
                                height: 300,
                                width: 300,
                                child: Image.asset('assets/start.png'),
                              ),
                              SizedBox(height: 60),
                              Text(
                                'Your personal breast cancer helper',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 130),
                              Container(
                                width: maxScreenWidth,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => SignInWithEmail()));
                                      },
                                      child: Container(
                                        width: 180,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.pink,
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "Sign In",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
                                      },
                                      child: Container(
                                        width: 180,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.pink.shade100,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Sign up",
                                            style: TextStyle(
                                              color: Colors.pink,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                      
                    ],
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
