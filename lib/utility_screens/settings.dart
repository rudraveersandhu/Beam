import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:html' as html;
import '../auth_screens/start_screen.dart';
import '../models/user_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  User? user;

  final picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  String hashPassword(String password) {
    var bytes = utf8.encode(password); // Convert the password to a list of bytes
    var digest = sha256.convert(bytes); // Hash the password using SHA-256
    return digest.toString(); // Convert the digest to a string
  }

  updateDetails(String name, String email, String number,String password){
    final model = context.read<UserModel>();
    user = FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance.collection('users').doc(user?.uid).update({
      'name': name,
      'email': email,
      'phone': number,
    });
    user?.updateEmail(email);
    model.name = name;
    model.email = email;
    model.number = number;

    if(password == 'null'){
    }else{
      user?.updatePassword(password);
    }

  }

  Future<void> uploadProfilePicture() async {
    final model = context.read<UserModel>();
    user = FirebaseAuth.instance.currentUser;

    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((e) async {
      final files = uploadInput.files;
      if (files?.isEmpty ?? true) return;

      final file = files!.first;
      final reader = html.FileReader();

      reader.onLoadEnd.listen((e) async {

        final fileBytes = reader.result as Uint8List;

        Reference storageReference = FirebaseStorage.instance.ref().child('${user?.uid}/profile_pictures/${file.name}');

        try {

          UploadTask uploadTask = storageReference.putData(fileBytes);
          await uploadTask;

          String downloadURL = await storageReference.getDownloadURL();
          FirebaseFirestore.instance.collection('users').doc(user?.uid).update({
            'profile_pic': downloadURL,
          });

          print("File uploaded successfully. Download URL: $downloadURL");
          setState(() {
            model.profilePicture = downloadURL;
          });
        } catch (e) {
          print("Error occurred while uploading profile picture: $e");
        }
      });

      reader.readAsArrayBuffer(file);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    final model = context.read<UserModel>();
    _passwordController.text  = 'null';
    _nameController.text = model.name;
    _emailController.text = model.email;
    _numberController.text = model.number;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.read<UserModel>();
    Timestamp timestamp = model.joinedOn;
    DateTime dateTime = timestamp.toDate();
    String formattedTime = DateFormat('hh:mm a').format(dateTime);

    double screen_width = MediaQuery.of(context).size.width;
    if(screen_width > 500){
      screen_width = 500;
      return Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.grey.shade100,
              width: screen_width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0,right: 16,top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                IconButton(
                                  icon: Icon(Icons.arrow_back),
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                SizedBox(height: 20,),
                                Text(
                                  'Settings',
                                  style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                                SizedBox(height: 2),
                                const Text(
                                  'Manage you account here',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 70.0),
                              child: Row(
                                children: [
                                  Text("Logout", style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.bold
                                  ),),
                                  SizedBox(width: 3,),
                                  IconButton(
                                    icon: Icon(Icons.logout),
                                    onPressed: () async {
                                      await FirebaseAuth.instance.signOut();
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              StartScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0,right: 16,top: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.pink.shade300,
                                              blurRadius: 10.0,
                                              spreadRadius: 2.0,
                                              offset: Offset(0, 1), // You can change the offset to your preference
                                            ),
                                          ],
                                        ),
                                        child: CircleAvatar(
                                          radius: 50,
                                          backgroundColor: Colors.white,
                                          child: ClipOval(
                                            child: CachedNetworkImage(
                                              imageUrl: model.profilePicture,
                                              placeholder: (context, url) => SizedBox(
                                                width: 100,
                                                height: 100,
                                                child: Center(
                                                  child: CircularProgressIndicator(color: Colors.pink.shade300),
                                                ),
                                              ),
                                              errorWidget: (context, url, error) => Icon(Icons.error),
                                              imageBuilder: (context, imageProvider) => Container(
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: GestureDetector(
                                          onTap: uploadProfilePicture,
                                          child: Icon(
                                            CupertinoIcons.plus_circle_fill,
                                            color: Colors.pink.shade600,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 300,height: 100,
                                    decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20,top: 10),
                                            child: Text(
                                              "Name: ${model.name}",
                                              style: TextStyle(
                                                fontSize: 16,
                                                //fontWeight: FontWeight.bold,
                                                color: Colors.grey.shade700
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20,top: 3),
                                            child: Text(
                                              "Joined : $formattedTime / ${dateTime.day}-${dateTime.month}-${dateTime.year} ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  //fontWeight: FontWeight.bold,
                                                  color: Colors.grey.shade700
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20,top: 3),
                                            child: Text(
                                              "At : ${formattedTime}",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  //fontWeight: FontWeight.bold,
                                                  color: Colors.grey.shade700
                                              ),
                                            ),
                                          ),

                                      ],)
                                  )
                                ],
                              ),
                              SizedBox(height: 8),

                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(
                    height: 2,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'welcome to your beam profile',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: TextFormField(
                      //controller: _nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                      initialValue: model.name,
                      onSaved: (value) {
                        setState(() {
                          //_email = value!;
                        });
                      },
                      onChanged: (value){
                        _nameController.text = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: TextFormField(
                      //controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                      initialValue: model.email,
                      onChanged: (value){
                        _emailController.text = value;

                      },
                      onSaved: (value) {
                        setState(() {
                          //_email = value!;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: TextFormField(
                      //controller: _numberController,
                      decoration: InputDecoration(labelText: 'Number'),
                      initialValue: model.number,
                      onChanged: (value){
                        _numberController.text = value;
                      },
                      onSaved: (value) {
                        setState(() {
                          //_email = value!;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }

                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: TextFormField(
                      //controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      //initialValue: "xxxxxxxx",
                      onSaved: (value) {
                        setState(() {
                          //_email = value!;
                        });
                      },
                      onChanged: (value){
                        if (value.length > 5 )  {
                          _passwordController.text = value;
                        }

                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 5) {
                          return 'Please enter a password greater than 5 digits';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 25),
                  GestureDetector(
                    onTap: (){
                      print("saving name: ${_nameController.text}");
                      print("saving email: ${_emailController.text}");
                      print("saving phone: ${_numberController.text}");
                      print("saving pass: ${_passwordController.text}");
                      updateDetails(_nameController.text,_emailController.text,_numberController.text,_passwordController.text);
                    },

                    child: Container(
                      height: 40,
                      width: 80,
                      decoration: BoxDecoration(
                          color: Colors.pink.shade500,
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      child: Center(child: Text('Save',
                      style: TextStyle(
                        color: Colors.white
                      ),)),
                    ),
                  )

                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.grey.shade100,
              width: screen_width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0,right: 16,top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                IconButton(
                                  icon: Icon(Icons.arrow_back),
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                SizedBox(height: 20,),
                                Text(
                                  'Settings',
                                  style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                                SizedBox(height: 2),
                                const Text(
                                  'Manage you account here',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 70.0),
                              child: Row(
                                children: [
                                  Text("Logout", style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.bold
                                  ),),
                                  SizedBox(width: 3,),
                                  IconButton(
                                    icon: Icon(Icons.logout),
                                    onPressed: () async {
                                      await FirebaseAuth.instance.signOut();
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              StartScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0,right: 16,top: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.pink.shade300,
                                              blurRadius: 10.0,
                                              spreadRadius: 2.0,
                                              offset: Offset(0, 1), // You can change the offset to your preference
                                            ),
                                          ],
                                        ),
                                        child: CircleAvatar(
                                          radius: 50,
                                          backgroundColor: Colors.white,
                                          child: ClipOval(
                                            child: CachedNetworkImage(
                                              imageUrl: model.profilePicture,
                                              placeholder: (context, url) => SizedBox(
                                                width: 100,
                                                height: 100,
                                                child: Center(
                                                  child: CircularProgressIndicator(color: Colors.pink.shade300),
                                                ),
                                              ),
                                              errorWidget: (context, url, error) => Icon(Icons.error),
                                              imageBuilder: (context, imageProvider) => Container(
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: GestureDetector(
                                          onTap: uploadProfilePicture,
                                          child: Icon(
                                            CupertinoIcons.plus_circle_fill,
                                            color: Colors.pink.shade600,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                      width: 300,height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white,),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20,top: 10),
                                            child: Text(
                                              "Name: ${model.name}",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  //fontWeight: FontWeight.bold,
                                                  color: Colors.grey.shade700
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20,top: 3),
                                            child: Text(
                                              "Joined : $formattedTime / ${dateTime.day}-${dateTime.month}-${dateTime.year} ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  //fontWeight: FontWeight.bold,
                                                  color: Colors.grey.shade700
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20,top: 3),
                                            child: Text(
                                              "At : ${formattedTime}",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  //fontWeight: FontWeight.bold,
                                                  color: Colors.grey.shade700
                                              ),
                                            ),
                                          ),

                                        ],)
                                  )
                                ],
                              ),
                              SizedBox(height: 8),

                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(
                    height: 2,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'welcome to your beam profile',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: TextFormField(
                      //controller: _nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                      initialValue: model.name,
                      onSaved: (value) {
                        setState(() {
                          //_email = value!;
                        });
                      },
                      onChanged: (value){
                        _nameController.text = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: TextFormField(
                      //controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                      initialValue: model.email,
                      onChanged: (value){
                        _emailController.text = value;

                      },
                      onSaved: (value) {
                        setState(() {
                          //_email = value!;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: TextFormField(
                      //controller: _numberController,
                      decoration: InputDecoration(labelText: 'Number'),
                      initialValue: model.number,
                      onChanged: (value){
                        _numberController.text = value;
                      },
                      onSaved: (value) {
                        setState(() {
                          //_email = value!;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }

                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: TextFormField(
                      //controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      //initialValue: "xxxxxxxx",
                      onSaved: (value) {
                        setState(() {
                          //_email = value!;
                        });
                      },
                      onChanged: (value){
                        if (value.length > 5 )  {
                          _passwordController.text = value;
                        }

                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 5) {
                          return 'Please enter a password greater than 5 digits';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 25),
                  GestureDetector(
                    onTap: (){
                      print("saving name: ${_nameController.text}");
                      print("saving email: ${_emailController.text}");
                      print("saving phone: ${_numberController.text}");
                      print("saving pass: ${_passwordController.text}");
                      updateDetails(_nameController.text,_emailController.text,_numberController.text,_passwordController.text);
                    },

                    child: Container(
                      height: 40,
                      width: 80,
                      decoration: BoxDecoration(
                          color: Colors.pink.shade500,
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      child: Center(child: Text('Save',
                        style: TextStyle(
                            color: Colors.white
                        ),)),
                    ),
                  )

                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
