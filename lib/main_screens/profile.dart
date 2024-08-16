import 'dart:io';
import 'dart:typed_data';
import 'package:beam/models/user_model.dart';
import 'package:beam/auth_screens/start_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:html' as html;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sendgrid_mailer/sendgrid_mailer.dart';
import '../utility_screens/counterScreen.dart';
import '../utility_screens/settings.dart';





class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  TextEditingController _nameController = TextEditingController();

  String mail_body = '';
  String mail_subject = '';
  User? user;

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    getName();
  }

  getName() async {
    final model = context.read<UserModel>();
    _nameController.text = model.name;
  }

  setName(String name){
    final model = context.read<UserModel>();
    user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection('users').doc(user?.uid).update({
      'name': name,
    });
    setState(() {
      model.name = name;
    });

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

  void _showEditDialog(String Name) {
    _nameController.text = Name;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.pink.shade200,
          title: Text(
            'Edit Name',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Enter your name',
              labelStyle: TextStyle(color: Colors.white),
            ),
            style: TextStyle(color: Colors.white60),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  setName(_nameController.text.toString());
                });
                Navigator.of(context).pop();
              },
              child: Container(
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = context.read<UserModel>();
    double screen_width = MediaQuery.of(context).size.width;
    if(screen_width > 500){
      screen_width = 500;
      return Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              width: screen_width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Profile',
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Welcome back ${model.name}!',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),

                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Center(
                                  child: Column(
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
                                      SizedBox(height: 8),
                                      Center(
                                        child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          /*Consumer<UserModel>(
                                            builder: (context, userProvider, child) {
                                              return Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage: NetworkImage(userProvider.profilePicture),
                                                    radius: 50,
                                                  ),
                                                  SizedBox(height: 20),
                                                  Text(
                                                    userProvider.name,
                                                    style: TextStyle(fontSize: 24),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),*/
                                          Text(
                                             model.name,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: (){
                                                _showEditDialog(_nameController.text);
                                              },
                                            child: Icon(
                                              Icons.edit,
                                              color: Colors.grey.shade600,
                                              size: 20,
                                            ),
                                          )
                                        ],
                                      ),),
                                      SizedBox(height: 4),
                                      Text(
                                        'welcome to your beam profile',
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.pink,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 32,
                                                vertical: 12,
                                              ),
                                            ),
                                            onPressed: () {},
                                            child: Text(
                                              'Feedback',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 16),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.grey[300],
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 32,
                                                vertical: 12,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
                                            },
                                            child: Text(
                                              'Settings',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 32),
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Send a Review or feedback',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                TextField(
                                  onChanged: (value) {
                                    mail_subject = value;
                                  },
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    hintText: 'Subject',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                TextField(
                                  onChanged: (value) {
                                    mail_body = value;
                                  },
                                  maxLines: 4,
                                  decoration: InputDecoration(
                                    hintText: 'Share your thoughts',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.pink,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 12,
                                    ),
                                  ),
                                  onPressed: () async {
                                    //sendMail(mail_subject, mail_body, 'rudraveersandhu@gmail.com');
                                    showAlert();
                                  },
                                  child: Text(
                                    'Send Feedback',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16),
                                model.email == 'rudraveersandhu@gmail.com' || model.email == 'ameyaaneja1@gmail.com'  ? ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.pink,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 12,
                                    ),
                                  ),
                                  onPressed: () async {
                                    Navigator.push(context, MaterialPageRoute(builder: (builder) => const CounterScreen() ));

                                  },
                                  child: Text(
                                    "View Visitor's count",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ) : Container()
                              ],
                            ),
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
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Container(
              //height: MediaQuery.of(context).size.height,
              color: Colors.white,
              width: screen_width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Profile',
                                      style: TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Welcome back ${model.name}!',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                        
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Center(
                                    child: Column(
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
                                        SizedBox(height: 8),
                                        Center(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              /*Consumer<UserModel>(
                                              builder: (context, userProvider, child) {
                                                return Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundImage: NetworkImage(userProvider.profilePicture),
                                                      radius: 50,
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      userProvider.name,
                                                      style: TextStyle(fontSize: 24),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),*/
                                              Text(
                                                model.name,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: (){
                                                  _showEditDialog(_nameController.text);
                                                },
                                                child: Icon(
                                                  Icons.edit,
                                                  color: Colors.grey.shade600,
                                                  size: 20,
                                                ),
                                              )
                                            ],
                                          ),),
                                        SizedBox(height: 4),
                                        Text(
                                          'welcome to your beam profile',
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(height: 16),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.pink,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 32,
                                                  vertical: 12,
                                                ),
                                              ),
                                              onPressed: () {},
                                              child: Text(
                                                'Feedback',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 16),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.grey[300],
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 32,
                                                  vertical: 12,
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
                                              },
                                              child: Text(
                                                'Settings',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 32),
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Send a Review or feedback',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  TextField(
                                    onChanged: (value) {
                                      mail_subject = value;
                                    },
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                      hintText: 'Subject',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  TextField(
                                    onChanged: (value) {
                                      mail_body = value;
                                    },
                                    maxLines: 4,
                                    decoration: InputDecoration(
                                      hintText: 'Share your thoughts',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.pink,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 32,
                                        vertical: 12,
                                      ),
                                    ),
                                    onPressed: () async {
                                      //sendMail(mail_subject, mail_body, 'rudraveersandhu@gmail.com');
                                      showAlert();
                                    },
                                    child: Text(
                                      'Send Feedback',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  model.email == 'rudraveersandhu@gmail.com' || model.email == 'ameyaaneja1@gmail.com' ? ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.pink,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 32,
                                        vertical: 12,
                                      ),
                                    ),
                                    onPressed: () async {
                                      Navigator.push(context, MaterialPageRoute(builder: (builder) => const CounterScreen() ));
                        
                                    },
                                    child: Text(
                                      "View Visitor's count",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ) : Container()
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(height: 200,)
                ],
              ),
            ),
          ),
        ),
      );
    }
  }



  Future<void> showAlert() async {
    showDialog(context: context,
        builder: (BuildContext context){
          return  AlertDialog(
            title: const Text("Mail Sent"),
            content: const Text("Feedback Submitted sucesfully!"),
            actions: [
              ElevatedButton(onPressed: (){
                Navigator.of(context).pop();
              }, child: const Text("close"))
            ],
          );
        }
    );
  }
}


