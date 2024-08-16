import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/user_model.dart';


class NewBlog extends StatefulWidget {
  const NewBlog({super.key});

  @override
  State<NewBlog> createState() => _NewBlogState();
}

class _NewBlogState extends State<NewBlog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _authorNameController = TextEditingController();
  final TextEditingController _authorPhotoUrlController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? user;

  String title = "";
  String content= "";
  String author= "";


  Future<void> publishBlog({
    required String title,
    required String content,
    required String authorName,
    required String authorPhotoUrl,
  }) async {
    user = FirebaseAuth.instance.currentUser;
    String blogId = Uuid().v4();

    final model = context.read<UserModel>();

    await _firestore.collection('blogs').doc(blogId).set({
      'blogID': blogId,
      'authorName': authorName,
      'authorPhotoUrl': authorPhotoUrl,
      'title': title,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
    }).then((value) {

      List<dynamic> blogs = model.blogs ;
      blogs.add(blogId);

      FirebaseFirestore.instance.collection('users').doc(user?.uid).update({
        'blogs': blogs
      });

      print("Blog Post Added");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Blog Post published sucessfully"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed: $error"),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    final model = context.read<UserModel>();
    _authorNameController.text = model.name;
    _authorPhotoUrlController.text = model.profilePicture;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screen_width = MediaQuery.of(context).size.width;
    double screen_height = MediaQuery.of(context).size.height;
    if(screen_width > 500){
      screen_width = 500;
      return Scaffold(
        //extendBody: true,
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Container(
              color: Colors.white,
              width: screen_width,
              height: screen_height,
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
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        GestureDetector(
                                            onTap:(){
                                              Navigator.pop(context);
                                            },
                                            child: Icon(Icons.arrow_back)),
                                        SizedBox(width: 10,),
                                        Text('Create Blogs for the community',
                                          style: TextStyle(
                                              fontSize: 21,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.grey.shade800

                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 2),


                                    Row(
                                      children: [
                                        SizedBox(width: 35),
                                        Text("Write and help other's heal!",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 20),

                            Padding(
                              padding: const EdgeInsets.only(left: 10.0,bottom: 20),
                              child: Text('New Blog',
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.grey.shade800
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: TextField(
                                controller: _titleController,
                                onChanged: (value){
                                  title = value;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Blog Title',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: TextField(
                                controller: _contentController,
                                onChanged: (value){
                                  content = value;
                                },
                                maxLines: 20,
                                decoration: InputDecoration(
                                  labelText: 'Blog Content',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(height: 30,),

                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [

                                  GestureDetector(
                                    onTap:(){
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1), // Shadow color with opacity
                                            spreadRadius: 3, // How much the shadow spreads
                                            blurRadius: 6, // How blurry the shadow is
                                            offset: Offset(1, 1), // Changes the position of the shadow
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.grey.shade700
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      publish_blog();
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.pink.shade400,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1), // Shadow color with opacity
                                            spreadRadius: 3, // How much the shadow spreads
                                            blurRadius: 6, // How blurry the shadow is
                                            offset: Offset(1, 1), // Changes the position of the shadow
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Publish',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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
          ),
        ),


      );
    } else {
      return Scaffold(
        //extendBody: true,
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Container(
              color: Colors.white,
              width: screen_width,
              height: screen_height,
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
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        GestureDetector(
                                            onTap:(){
                                              Navigator.pop(context);
                                            },
                                            child: Icon(Icons.arrow_back)),
                                        SizedBox(width: 10,),
                                        Text('Create Blogs for the community',
                                          style: TextStyle(
                                              fontSize: 21,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.grey.shade800

                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 2),


                                    Row(
                                      children: [
                                        SizedBox(width: 35),
                                        Text("Write and help other's heal!",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 20),

                            Padding(
                              padding: const EdgeInsets.only(left: 10.0,bottom: 20),
                              child: Text('New Blog',
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.grey.shade800
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: TextField(
                                controller: _titleController,
                                onChanged: (value){
                                  title = value;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Blog Title',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: TextField(
                                controller: _contentController,
                                onChanged: (value){
                                  content = value;
                                },
                                maxLines: 20,
                                decoration: InputDecoration(
                                  labelText: 'Blog Content',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(height: 30,),

                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [

                                  GestureDetector(
                                    onTap:(){
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1), // Shadow color with opacity
                                            spreadRadius: 3, // How much the shadow spreads
                                            blurRadius: 6, // How blurry the shadow is
                                            offset: Offset(1, 1), // Changes the position of the shadow
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.grey.shade700
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      publish_blog();


                                    },
                                    child: Container(
                                      height: 50,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.pink.shade400,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1), // Shadow color with opacity
                                            spreadRadius: 3, // How much the shadow spreads
                                            blurRadius: 6, // How blurry the shadow is
                                            offset: Offset(1, 1), // Changes the position of the shadow
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Publish',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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
          ),
        ),


      );
    }


  }

  publish_blog(){
    try{
      if( _titleController.text != '' && _contentController.text != '' && _authorNameController.text != ''){
        publishBlog(
            title: _titleController.text,
            content: _contentController.text,
            authorName: _authorNameController.text,
            authorPhotoUrl: _authorPhotoUrlController.text
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Enter all the requires feilds'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }catch(e){
      print("Error: $e");
    }

  }

  addBlog(String title, String content, String author, DateTime date) async {
    final box = await Hive.openBox('Blogs');

    var blog_titles = await box.get('blog_titles') ?? <String>[];
    var blog_content = await box.get('blog_content') ?? <String>[];
    var blog_author = await box.get('blog_author') ?? <String>[];
    //var blog_date = await box.get('blog_date') ?? <DateTime>[];

    blog_titles.add(title);
    blog_content.add(content);
    blog_author.add(author);
    //blog_date.add(date);

    await box.put('blog_titles', blog_titles);
    await box.put('blog_content', blog_content);
    await box.put('blog_author', blog_author);
    //await box.put('blog_date', blog_date);

    Navigator.pop(context);
  }
}
