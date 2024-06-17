import 'package:beam/models/user_model.dart';
import 'package:beam/auth_screens/sign_in.dart';
import 'package:beam/auth_screens/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class SignInWithEmail extends StatefulWidget {
  const SignInWithEmail({super.key});

  @override
  State<SignInWithEmail> createState() => _SignInWithEmailState();
}



class _SignInWithEmailState extends State<SignInWithEmail> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  counterIncrement() async {
    final counterDoc = FirebaseFirestore.instance.collection('visits').doc('counter');
    final counterDocSnapshot = await counterDoc.get();
    if (counterDocSnapshot.exists) {
      int x = counterDocSnapshot['count'] ?? 0;
      await counterDoc.set({'count': x + 1});
    } else {
      await counterDoc.set({'count': 1});
    }
  }

  void _signInWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      print("User signed in: ${userCredential.user?.email}");
      _getUserInfo();
    } on FirebaseAuthException catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _getUserInfo() async {
    final model = context.read<UserModel>();
    final user = FirebaseAuth.instance.currentUser;

    try{
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

        } else {
          print('user is null');
        }
        await counterIncrement();
      go();
    }catch(e){
      print('error: $e');
    }
  }

  go(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
  }

  void _showLoadingDialog() {

    showDialog(
      barrierColor: Colors.black.withOpacity(.65),
      context: context,
      barrierDismissible: true, // Prevents dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.pink,
          content: Container(
            color: Colors.pink.withOpacity(.85),
            //width: 100, // Adjust the width as needed
            height: 220, // Adjust the height as needed to make it square
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.white,),
                SizedBox(height: 20),
                Text('Signing in...',style: TextStyle(
                    color: Colors.white
                ),),
              ],
            ),
          ),
        );
      },
    );

    // Simulate a network call or a task with a delay

  }

  void _sendSignInLink() async {
    final ActionCodeSettings actionCodeSettings = ActionCodeSettings(
      url: 'https://your-app.firebaseapp.com',
      handleCodeInApp: true,
      iOSBundleId: 'com.example.ios',
      androidPackageName: 'com.example.android',
      androidInstallApp: true,
      androidMinimumVersion: '12',
    );

    try {
      await _auth.sendSignInLinkToEmail(
        email: _emailController.text,
        actionCodeSettings: actionCodeSettings,
      );
      print('Sign-in link sent to email');
    } on FirebaseAuthException catch (e) {
      print('Error: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    double screen_width = MediaQuery.of(context).size.width;

    if(screen_width > 500){
      screen_width = 500;
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: screen_width,
                child: Image.asset('assets/signinbg.JPG',
                  fit: BoxFit.fitWidth,),

              ),
              Container(
                width: screen_width,
                height: MediaQuery.of(context).size.height,
                color: Colors.pink.withOpacity(0.85),
              ),
              Container(
                width: screen_width,
                height: MediaQuery.of(context).size.height,
                color: Colors.white.withOpacity(0.35),
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SafeArea(
                                child: Text('',
                                ),
                              ),

                              Text('B e a m',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 70,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white
                                ),
                              ),
                              SizedBox(height: 30),

                              Padding(
                                padding: const EdgeInsets.only(right: 50),
                                child: Container(
                                  width: 300,
                                  child: Image.asset('assets/cn.png'),
                                ),
                              ),


                              SizedBox(height: 80),
                              Container(
                                width: 300,
                                child: TextField(
                                  controller: _emailController,
                                  onChanged: (value){
                                    //pass = value;
                                  },
                                  style: TextStyle(
                                    color: Colors.white, // Set the text color
                                  ),

                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.email_outlined,),
                                    labelText: 'Email',
                                    prefixIconColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    labelStyle: TextStyle(
                                        color: Colors.white
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white), // Set the border color when the TextField is enabled
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              Container(
                                width: 300,
                                child: TextField(
                                  controller: _passwordController,
                                  onChanged: (value){
                                    //pass = value;
                                  },
                                  style: TextStyle(
                                    color: Colors.white, // Set the text color
                                  ),
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.fingerprint),
                                    labelText: 'Password',
                                    prefixIconColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    labelStyle: TextStyle(
                                        color: Colors.white
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white), // Set the border color when the TextField is enabled
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              Container(width: 300,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        //_showLoadingDialog();
                                        //_signInWithEmailAndPassword();
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn()));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                          color: Colors.pink.shade500,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1), // Shadow color with opacity
                                              spreadRadius: 2, // How much the shadow spreads
                                              blurRadius: 5, // How blurry the shadow is
                                              // Changes the position of the shadow
                                            ),
                                          ],
                                        ),
                                        width: 130,
                                        height: 40,
                                        child: Center(
                                          child: Text("Login with OTP",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        _showLoadingDialog();
                                        _signInWithEmailAndPassword();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1), // Shadow color with opacity
                                              spreadRadius: 2, // How much the shadow spreads
                                              blurRadius: 5, // How blurry the shadow is
                                              // Changes the position of the shadow
                                            ),
                                          ],
                                        ),
                                        width: 130,
                                        height: 40,
                                        child: Center(
                                          child: Text("Login",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10,),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
                                },
                                child: Text('Dont have an Account? Sign up',style: TextStyle(
                                    color: Colors.white
                                ),),
                              ),

                              SizedBox(height: 20),
                              Text('OR'),
                              SizedBox(height: 16),
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    color: Colors.pink,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1), // Shadow color with opacity
                                        spreadRadius: 2, // How much the shadow spreads
                                        blurRadius: 5, // How blurry the shadow is
                                        // Changes the position of the shadow
                                      ),
                                    ],
                                  ),
                                  width: 130,
                                  height: 40,
                                  child: Center(
                                    child: Text("Sign Up",
                                      style: TextStyle(
                                          color: Colors.white
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),

                            ],
                          ),
                        ),
                      ),



                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: screen_width,
                child: Image.asset('assets/signinbg.JPG',
                  fit: BoxFit.fitWidth,),

              ),
              Container(
                width: screen_width,
                height: MediaQuery.of(context).size.height,
                color: Colors.pink.withOpacity(0.85),
              ),
              Container(
                width: screen_width,
                height: MediaQuery.of(context).size.height,
                color: Colors.white.withOpacity(0.35),
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SafeArea(
                                child: Text('',
                                ),
                              ),

                              Text('B e a m',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 70,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white
                                ),
                              ),
                              SizedBox(height: 30),

                              Padding(
                                padding: const EdgeInsets.only(right: 50),
                                child: Container(
                                  width: 300,
                                  child: Image.asset('assets/cn.png'),
                                ),
                              ),


                              SizedBox(height: 80),
                              Container(
                                width: 300,
                                child: TextField(
                                  controller: _emailController,
                                  onChanged: (value){
                                    //pass = value;
                                  },
                                  style: TextStyle(
                                    color: Colors.white, // Set the text color
                                  ),

                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.email_outlined,),
                                    labelText: 'Email',
                                    prefixIconColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    labelStyle: TextStyle(
                                        color: Colors.white
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white), // Set the border color when the TextField is enabled
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              Container(
                                width: 300,
                                child: TextField(
                                  controller: _passwordController,
                                  onChanged: (value){
                                    //pass = value;
                                  },
                                  style: TextStyle(
                                    color: Colors.white, // Set the text color
                                  ),
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.fingerprint),
                                    labelText: 'Password',
                                    prefixIconColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    labelStyle: TextStyle(
                                        color: Colors.white
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white), // Set the border color when the TextField is enabled
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              Container(width: 300,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        //_showLoadingDialog();
                                        //_signInWithEmailAndPassword();
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn()));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                          color: Colors.pink.shade500,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1), // Shadow color with opacity
                                              spreadRadius: 2, // How much the shadow spreads
                                              blurRadius: 5, // How blurry the shadow is
                                              // Changes the position of the shadow
                                            ),
                                          ],
                                        ),
                                        width: 130,
                                        height: 40,
                                        child: Center(
                                          child: Text("Login with OTP",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        _showLoadingDialog();
                                        _signInWithEmailAndPassword();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1), // Shadow color with opacity
                                              spreadRadius: 2, // How much the shadow spreads
                                              blurRadius: 5, // How blurry the shadow is
                                              // Changes the position of the shadow
                                            ),
                                          ],
                                        ),
                                        width: 130,
                                        height: 40,
                                        child: Center(
                                          child: Text("Login",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10,),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
                                },
                                child: Text('Dont have an Account? Sign up',style: TextStyle(
                                    color: Colors.white
                                ),),
                              ),

                              SizedBox(height: 20),
                              Text('OR'),
                              SizedBox(height: 16),
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    color: Colors.pink,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1), // Shadow color with opacity
                                        spreadRadius: 2, // How much the shadow spreads
                                        blurRadius: 5, // How blurry the shadow is
                                        // Changes the position of the shadow
                                      ),
                                    ],
                                  ),
                                  width: 130,
                                  height: 40,
                                  child: Center(
                                    child: Text("Sign Up",
                                      style: TextStyle(
                                          color: Colors.white
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),

                            ],
                          ),
                        ),
                      ),



                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
