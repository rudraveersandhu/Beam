import 'package:beam/auth_screens/sign_in_with_email.dart';
import 'package:beam/auth_screens/sign_up.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../models/user_model.dart';


class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _phoneController  = TextEditingController();
  final TextEditingController _cnCodeController = TextEditingController();
  final TextEditingController _otpController    = TextEditingController();

  String _verificationId = '';
  String pass            = '';
  int    num             = 0;

  @override
  void initState() {
    _cnCodeController.text = "+91";
    super.initState();
  }

  void _showOTPDialog(BuildContext context) {
    List<TextEditingController> otpControllers = List.generate(6, (_) => TextEditingController());
    List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.pink.shade200.withOpacity(.8),
          title: const Center(
            child: Text(
              'Beam OTP',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SizedBox(
                      width: 40,
                      child: TextField(
                        controller: otpControllers[index],
                        focusNode: focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        decoration: InputDecoration(
                          fillColor: Colors.white70,
                          filled: true,
                          counterText: '', // Hide the counter text
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          if (value.length == 1 && index < 5) {
                            FocusScope.of(context).requestFocus(focusNodes[index + 1]);
                          }
                          if (value.isEmpty && index > 0) {
                            FocusScope.of(context).requestFocus(focusNodes[index - 1]);
                          }
                        },
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String otp = otpControllers.map((controller) => controller.text.trim()).join();

                // Validate OTP input
                if (otp.isEmpty || otp.length < 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter the OTP'),
                      backgroundColor: Colors.red, // Set background color to red
                    ),
                  );
                  return;
                }

                _otpController.text = otp;

                // Show loading indicator while verifying OTP
                _showLoadingDialog();


                // Close OTP dialog
                Navigator.of(context).pop();

                // Verify OTP
                _verifyOTP();

                // Close loading indicator
                Navigator.of(context).pop();
              },
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(10)
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(' Submit ',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _sendOTP() async {
    final phoneNumber = _cnCodeController.text.trim()+_phoneController.text.trim();
    print("Phone Number: $phoneNumber");
    if (!_isValidPhoneNumber(phoneNumber)) {
      setState(() {
      });
      return;
    } else {
      print("Number is valid, sending OTP");
    }

    setState(() {
    });

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        print("verification completed");
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print("verification failed $e");
        setState(() {
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        print("Code Sent Sucessfully");
        setState(() {
          _verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
    );
  }

  void _verifyOTP() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _otpController.text,
      );
      print('verifying otp');
      await _auth.signInWithCredential(credential);
      await _signup();
      print('OTP verified successfully');
    } catch (e) {
      print('Error verifying OTP: $e');
    }
  }

  Future<void> _signup() async {
    DateTime now = DateTime.now();
    Timestamp x = Timestamp.fromDate(now);
    final model = context.read<UserModel>();
    try {
      User? user = _auth.currentUser;

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();
      if (!userSnapshot.exists) {

        print("timestamp: $x");

        await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
          'id' : user?.uid,
          'name': '',
          'phone': _phoneController.text.trim(),
          'email': '',
          'password': '',
          'blogs' : [],
          'profile_pic' : 'https://firebasestorage.googleapis.com/v0/b/beam-care.appspot.com/o/placeholder.png?alt=media&token=1244b6ef-2cdf-459e-9c1c-d6d5aa1978dc',
          'joined_on' : x
        });

        model.id = user!.uid;
        model.name = '';
        model.profilePicture = 'https://firebasestorage.googleapis.com/v0/b/beam-care.appspot.com/o/placeholder.png?alt=media&token=1244b6ef-2cdf-459e-9c1c-d6d5aa1978dc';
        model.email = '';
        model.pass = '';
        model.number = _phoneController.text.trim();
        model.blogs = [];
        model.joinedOn = x;

        await counterIncrement();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sign up Successful'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
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

        } else {
          print('user is null');
        }

      }
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

  bool _isValidPhoneNumber(String phoneNumber) {
    final regex = RegExp(r'^\+\d{1,3}\d{1,14}$');
    print('checking number format');
    print(regex.hasMatch(phoneNumber));
    return regex.hasMatch(phoneNumber);
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


                              SizedBox(height: 100),
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
                                    width: 190,
                                    child: TextField(
                                      controller: _phoneController,
                                      onChanged: (value){
                                        num = int.parse(value);
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
                              SizedBox(height: 20),
                              Container(
                                width: 300,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => SignInWithEmail()));
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
                                        width: 140,
                                        height: 40,
                                        child: Center(
                                          child: Text("Login with E-Mail",
                                          ),
                                        ),
                                      ),
                                    ),

                                    GestureDetector(
                                      onTap: (){
                                        _sendOTP();
                                        _showOTPDialog(context);
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
                                        width: 140,
                                        height: 40,
                                        child: Center(
                                          child: Text("Login with OTP",
                                              style: TextStyle(
                                                color: Colors.white
                                              ),
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


                              SizedBox(height: 100),
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
                                    width: 190,
                                    child: TextField(
                                      controller: _phoneController,
                                      onChanged: (value){
                                        num = int.parse(value);
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
                              SizedBox(height: 20),
                              Container(
                                width: 300,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => SignInWithEmail()));
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
                                        width: 140,
                                        height: 40,
                                        child: Center(
                                          child: Text("Login with E-Mail",
                                          ),
                                        ),
                                      ),
                                    ),

                                    GestureDetector(
                                      onTap: (){
                                        _sendOTP();
                                        _showOTPDialog(context);
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
                                        width: 140,
                                        height: 40,
                                        child: Center(
                                          child: Text("Login with OTP",
                                            style: TextStyle(
                                                color: Colors.white
                                            ),
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
