import 'dart:async';
import 'package:beam/auth_screens/sign_in_with_email.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import '../models/user_model.dart'; // for utf8.encode

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController _cnCodeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _phoneController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
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

  @override
  void initState() {
    // TODO: implement initState
    _cnCodeController.text = '+91';
    super.initState();
  }

  void _showLoadingDialog() {

    showDialog(
      barrierColor: Colors.black.withOpacity(.65),
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.pink,
          content: Container(
            color: Colors.pink.withOpacity(.85),
            height: 220,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.white,),
                SizedBox(height: 20),
                Text('Signing you up...',style: TextStyle(
                  color: Colors.white
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _signup() async {
    final model = context.read<UserModel>();
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = _auth.currentUser;
      DateTime now = DateTime.now();
      Timestamp x = Timestamp.fromDate(now);
      print("timestamp: $x");

      await _firestore.collection('users').doc(user?.uid).set({
        'id' : user?.uid,
        'name': _fullNameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
        'password': hashPassword(_passwordController.text.trim()),
        'blogs' : [],
        'profile_pic' : 'https://firebasestorage.googleapis.com/v0/b/beam-care.appspot.com/o/placeholder.png?alt=media&token=1244b6ef-2cdf-459e-9c1c-d6d5aa1978dc',
        'joined_on' : x
      }).then((onValue){
        model.id = user!.uid;
        model.name = _fullNameController.text.trim();
        model.profilePicture = 'https://firebasestorage.googleapis.com/v0/b/beam-care.appspot.com/o/placeholder.png?alt=media&token=1244b6ef-2cdf-459e-9c1c-d6d5aa1978dc';
        model.email = _emailController.text.trim();
        model.pass = hashPassword(_passwordController.text.trim());
        model.number = _phoneController.text.trim();
        model.blogs = [];
        model.joinedOn = x;
      });

      await counterIncrement();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sign up Successful'),
            backgroundColor: Colors.green,
          ),
        );

        setState(() {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
        });
      } catch (e) {
        print('Error saving user details to Firestore: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
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
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: screen_width,
                  child: Image.asset('assets/signinbg.JPG',
                    fit: BoxFit.fitWidth,),
                ),
              ),
              Center(
                child: Container(
                  width: screen_width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.pink.withOpacity(0.70),
                ),
              ),
              Center(
                child: Container(
                  width: screen_width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.white.withOpacity(0.50),
                ),
              ),

              Center(
                child: Container(
                  width: screen_width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.pink.withOpacity(0.45),
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
                                Container(
                                  width: screen_width-100,
                                  child: Image.asset('assets/people.png'),
                                ),
                                Text(
                                  'Get On Board!',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                const Text(
                                  'Create your profile to start your Journey.',
                                  style: TextStyle(fontSize: 16,color: Colors.white),
                                  textAlign: TextAlign.center,

                                ),
                                SizedBox(height: 32),
                                Container(
                                  width: 350,
                                  child:  TextFormField(
                                    controller: _fullNameController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your name';
                                      }
                                      return null;
                                    },
                                    style: const TextStyle(
                                      color: Colors.white, // Set the text color
                                    ),
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.person),
                                      prefixIconColor: Colors.white,
                                      labelText: 'Full Name',
                                      border: OutlineInputBorder(),
                                      labelStyle: TextStyle(
                                          color: Colors.white
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white), // Set the border color when the TextField is enabled
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white), // Set the border color when the TextField is focused
                                      ),
                                    ),
                                    onChanged: (value){

                                    },
                                  ),
                                ),
                                SizedBox(height: 16),
                                Container(
                                  width: 350,
                                  child:  TextFormField(
                                    controller: _emailController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your Email';
                                      }
                                      return null;
                                    },
                                    style: const TextStyle(
                                      color: Colors.white, // Set the text color
                                    ),
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.email_outlined),
                                      prefixIconColor: Colors.white,
                                      labelText: 'Email',
                                      border: OutlineInputBorder(),
                                      labelStyle: TextStyle(
                                          color: Colors.white
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white), // Set the border color when the TextField is enabled
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white), // Set the border color when the TextField is focused
                                      ),
                                    ),
                                    onChanged: (value){

                                    },

                                  ),
                                ),
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      color: Colors.white70,
                                      width: 100,
                                      height: 50,
                                      child:  CountryCodePicker(
                                        onChanged: (value){
                                          _cnCodeController.text = value.toString();
                                        },
                                        // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                        initialSelection: 'IN',
                                        favorite: ['+91','IN'],
                                        // optional. Shows only country name and flag
                                        showCountryOnly: false,
                                        // optional. Shows only country name and flag when popup is closed.
                                        showOnlyCountryWhenClosed: false,
                                        // optional. aligns the flag and the Text left
                                        alignLeft: false,
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Container(
                                      width: 240,
                                      child: TextField(
                                        controller: _phoneController,
                                        onChanged: (value){
                                        },
                                        style: const TextStyle(
                                          color: Colors.white, // Set the text color
                                        ),
                                        decoration: const InputDecoration(
                                          prefixIcon: Icon(CupertinoIcons.phone),
                                          prefixIconColor: Colors.white,
                                          labelText: 'Number',
                                          border: OutlineInputBorder(),
                                          labelStyle: TextStyle(
                                              color: Colors.white
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.white), // Set the border color when the TextField is enabled
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.white), // Set the border color when the TextField is focused
                                          ),
                                        ),

                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),

                                Container(
                                  width: 350,
                                  child: TextField(
                                    controller: _passwordController,
                                    onChanged: (value){
                                    },
                                    style: TextStyle(
                                      color: Colors.white, // Set the text color
                                    ),
                                    obscureText: true,
                                    decoration: InputDecoration(
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
                                SizedBox(height: 32),
                                GestureDetector(
                                  onTap: () async {
                                    _showLoadingDialog();
                                    await _signup();
                                    //await updateQ(_fullNameController.text.trim(),_emailController.text.trim(),int.parse(_phoneController.text.trim()),_passwordController.text.trim());

                                    //await _signUp(_cnCodeController.text+_phoneNumber,_name,_password);
                                    /*Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>  OtpScreen(
                                        phonenumber: _cnCodeController.text+_phoneNumber,
                                        name: _name,
                                        password: _password,
                                        verificationID: _verificationId,)),
                                    );*/
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
                                      child: Text("Sign Up",
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text('OR'),
                                SizedBox(height: 16),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignInWithEmail()));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                      color: Colors.pink.shade200,
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
                                      child: Text("Sign In",
                                        style: TextStyle(
                                            color: Colors.white
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16),
                                TextButton(
                                  onPressed: () {
                                    // Handle login navigation
                                  },
                                  child: Text('Already have an Account? LOGIN',style: TextStyle(
                                      color: Colors.white
                                  ),),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

    } else
    {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Stack(
            children: [
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: screen_width,
                  child: Image.asset('assets/signinbg.JPG',
                    fit: BoxFit.fitWidth,),
                ),
              ),
              Center(
                child: Container(
                  width: screen_width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.pink.withOpacity(0.70),
                ),
              ),
              Center(
                child: Container(
                  width: screen_width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.white.withOpacity(0.50),
                ),
              ),

              Center(
                child: Container(
                  width: screen_width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.pink.withOpacity(0.45),
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
                                Container(
                                  width: screen_width-100,
                                  child: Image.asset('assets/people.png'),
                                ),
                                Text(
                                  'Get On Board!',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                const Text(
                                  'Create your profile to start your Journey.',
                                  style: TextStyle(fontSize: 16,color: Colors.white),
                                  textAlign: TextAlign.center,

                                ),
                                SizedBox(height: 32),
                                Container(
                                  width: 350,
                                  child:  TextFormField(
                                    controller: _fullNameController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your name';
                                      }
                                      return null;
                                    },
                                    style: const TextStyle(
                                      color: Colors.white, // Set the text color
                                    ),
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.person),
                                      prefixIconColor: Colors.white,
                                      labelText: 'Full Name',
                                      border: OutlineInputBorder(),
                                      labelStyle: TextStyle(
                                          color: Colors.white
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white), // Set the border color when the TextField is enabled
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white), // Set the border color when the TextField is focused
                                      ),
                                    ),
                                    onChanged: (value){

                                    },
                                  ),
                                ),
                                SizedBox(height: 16),
                                Container(
                                  width: 350,
                                  child:  TextFormField(
                                    controller: _emailController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your Email';
                                      }
                                      return null;
                                    },
                                    style: const TextStyle(
                                      color: Colors.white, // Set the text color
                                    ),
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.email_outlined),
                                      prefixIconColor: Colors.white,
                                      labelText: 'Email',
                                      border: OutlineInputBorder(),
                                      labelStyle: TextStyle(
                                          color: Colors.white
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white), // Set the border color when the TextField is enabled
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white), // Set the border color when the TextField is focused
                                      ),
                                    ),
                                    onChanged: (value){

                                    },

                                  ),
                                ),
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      color: Colors.white70,
                                      width: 100,
                                      height: 50,
                                      child:  CountryCodePicker(
                                        onChanged: (value){
                                          _cnCodeController.text = value.toString();
                                        },
                                        // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                        initialSelection: 'IN',
                                        favorite: ['+91','IN'],
                                        // optional. Shows only country name and flag
                                        showCountryOnly: false,
                                        // optional. Shows only country name and flag when popup is closed.
                                        showOnlyCountryWhenClosed: false,
                                        // optional. aligns the flag and the Text left
                                        alignLeft: false,
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Container(
                                      width: 240,
                                      child: TextField(
                                        controller: _phoneController,
                                        onChanged: (value){
                                        },
                                        style: const TextStyle(
                                          color: Colors.white, // Set the text color
                                        ),
                                        decoration: const InputDecoration(
                                          prefixIcon: Icon(CupertinoIcons.phone),
                                          prefixIconColor: Colors.white,
                                          labelText: 'Number',
                                          border: OutlineInputBorder(),
                                          labelStyle: TextStyle(
                                              color: Colors.white
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.white), // Set the border color when the TextField is enabled
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.white), // Set the border color when the TextField is focused
                                          ),
                                        ),

                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),

                                Container(
                                  width: 350,
                                  child: TextField(
                                    controller: _passwordController,
                                    onChanged: (value){
                                    },
                                    style: TextStyle(
                                      color: Colors.white, // Set the text color
                                    ),
                                    obscureText: true,
                                    decoration: InputDecoration(
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
                                SizedBox(height: 32),
                                GestureDetector(
                                  onTap: () async {
                                    _showLoadingDialog();
                                    await _signup();
                                    //await updateQ(_fullNameController.text.trim(),_emailController.text.trim(),int.parse(_phoneController.text.trim()),_passwordController.text.trim());

                                    //await _signUp(_cnCodeController.text+_phoneNumber,_name,_password);
                                    /*Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>  OtpScreen(
                                        phonenumber: _cnCodeController.text+_phoneNumber,
                                        name: _name,
                                        password: _password,
                                        verificationID: _verificationId,)),
                                    );*/
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
                                      child: Text("Sign Up",
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text('OR'),
                                SizedBox(height: 16),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignInWithEmail()));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                      color: Colors.pink.shade200,
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
                                      child: Text("Sign In",
                                        style: TextStyle(
                                            color: Colors.white
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16),
                                TextButton(
                                  onPressed: () {
                                    // Handle login navigation
                                  },
                                  child: Text('Already have an Account? LOGIN',style: TextStyle(
                                      color: Colors.white
                                  ),),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
