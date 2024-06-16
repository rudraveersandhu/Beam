import 'package:beam/utility_screens/readblog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import 'new_blog.dart';

class MyBlogs extends StatefulWidget {
  const MyBlogs({super.key});

  @override
  State<MyBlogs> createState() => _MyBlogsState();
}

class _MyBlogsState extends State<MyBlogs> {
  late Future<List<Map<String, dynamic>>> userBlogs;

  @override
  void initState() {
    final model = context.read<UserModel>();
    super.initState();
    userBlogs = fetchUserBlogs(model.blogs);
  }

  Future<List<Map<String, dynamic>>> fetchUserBlogs(List<dynamic> blogID) async {
    List<Map<String, dynamic>> blogs = [];
    for(int i = 0; i<blogID.length ; i++){
      QuerySnapshot blogSnapshot = await FirebaseFirestore.instance
          .collection('blogs')
          .where('blogID', isEqualTo: blogID[i])
          .get();

      blogSnapshot.docs.forEach((doc) {
        blogs.add({
          'id': doc.id,
          'title': doc['title'],
          'content': doc['content'],
          'authorName': doc['authorName'],
          'authorPhotoUrl': doc['authorPhotoUrl'],
          'timestamp': doc['timestamp'],
        });
      });
    }
    return blogs;
  }

  convertTime(Timestamp timestamp){
    DateTime dateTime = timestamp.toDate();
    String formattedTime = DateFormat('hh:mm a').format(dateTime);
    return formattedTime;
  }

  convertDate(DateTime dateTime){
    String date = "${dateTime.day}-${dateTime.month}-${dateTime.year}";
    return date;
  }

  @override
  Widget build(BuildContext context) {
    double screen_width = MediaQuery.of(context).size.width;

    if(screen_width > 500){
      screen_width = 500;
      return Scaffold(
        //extendBody: true,
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          //controller: _controller,
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
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back),
                              onPressed: () async {
                                Navigator.of(context).pop();
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('My Blogs',
                                      style: TextStyle(
                                          fontSize: 21,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.grey.shade800

                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    const Text('A Collection of your written blogs!',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600
                                      ),
                                    ),

                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 13.0,right: 4),
                                  child: Icon(Icons.notifications_none, color: Colors.grey),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Divider(height: 2,),
                            SizedBox(
                              height: 15,
                            ),
                            // add further code here
                            FutureBuilder<List<Map<String, dynamic>>>(
                              future: userBlogs,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error fetching data');
                                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                                  return Center(
                                    child: Column(
                                      children: [
                                        Text('- - - - - - - - - - - - - - - - - - - - - - - No blogs found - - - - - - - - - - - - - - - - - - - - - - - '),
                                        SizedBox(height: 20,),
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) =>  NewBlog()),
                                            );
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(30),
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
                                            child: Icon(Icons.add,color: Colors.grey.shade500,),
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text('Write a blog',style: TextStyle(
                                          color: Colors.grey.shade700
                                        ),),
                                      ],
                                    ),
                                  );
                                } else {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      final blog = snapshot.data![index];
                                      return GestureDetector(
                                        onTap: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ReadBlog(
                                                blog_title: blog['title'],
                                                blog_content: blog['content'],
                                                blog_author: blog['authorName'],
                                                blog_date: 'Author: ${blog['authorName']}  |  On: ${convertDate(blog['timestamp'].toDate())} ${convertTime(blog['timestamp'])}',
                                                blog_author_url: blog['authorPhotoUrl'],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Card(
                                          color: Colors.pink.shade100.withBlue(1000).withGreen(1000).withRed(1022),
                                          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                                          elevation: 50,
                                          child: ListTile(
                                            title: Text(blog['title']),
                                            subtitle: Text('Author: ${blog['authorName']}  |  On: ${convertDate(blog['timestamp'].toDate())} ${convertTime(blog['timestamp'])}'),
                                            leading: CircleAvatar(
                                              radius: 20,
                                              backgroundColor: Colors.white,
                                              child: ClipOval(
                                                child: CachedNetworkImage(
                                                  imageUrl: blog['authorPhotoUrl'],
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
                                            trailing: GestureDetector(
                                                onTap: (){
                                                  deleteBlog(blog['id']);
                                                },
                                                child: Icon(Icons.delete_forever,color: Colors.red.shade700,size: 35,)),
                                          ),

                                        ),
                                      );
                                    },
                                  );
                                }
                              },
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
          //controller: _controller,
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
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back),
                              onPressed: () async {
                                Navigator.of(context).pop();
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('My Blogs',
                                      style: TextStyle(
                                          fontSize: 21,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.grey.shade800

                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    const Text('A Collection of your written blogs!',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600
                                      ),
                                    ),

                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 13.0,right: 4),
                                  child: Icon(Icons.notifications_none, color: Colors.grey),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Divider(height: 2,),
                            SizedBox(
                              height: 15,
                            ),
                            // add further code here
                            FutureBuilder<List<Map<String, dynamic>>>(
                              future: userBlogs,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error fetching data');
                                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                                  return Center(
                                    child: Column(
                                      children: [
                                        Text('- - - - - - - - - - - - - - - - - - - - - - - No blogs found - - - - - - - - - - - - - - - - - - - - - - - '),
                                        SizedBox(height: 20,),
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) =>  NewBlog()),
                                            );
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(30),
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
                                            child: Icon(Icons.add,color: Colors.grey.shade500,),
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text('Write a blog',style: TextStyle(
                                            color: Colors.grey.shade700
                                        ),),
                                      ],
                                    ),
                                  );
                                } else {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      final blog = snapshot.data![index];
                                      return GestureDetector(
                                        onTap: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ReadBlog(
                                                blog_title: blog['title'],
                                                blog_content: blog['content'],
                                                blog_author: blog['authorName'],
                                                blog_date: 'Author: ${blog['authorName']}  |  On: ${convertDate(blog['timestamp'].toDate())} ${convertTime(blog['timestamp'])}',
                                                blog_author_url: blog['authorPhotoUrl'],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Card(
                                          color: Colors.pink.shade100.withBlue(1000).withGreen(1000).withRed(1022),
                                          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                                          elevation: 50,
                                          child: ListTile(
                                            title: Text(blog['title']),
                                            subtitle: Text('Author: ${blog['authorName']}  |  On: ${convertDate(blog['timestamp'].toDate())} ${convertTime(blog['timestamp'])}'),
                                            leading: CircleAvatar(
                                              radius: 20,
                                              backgroundColor: Colors.white,
                                              child: ClipOval(
                                                child: CachedNetworkImage(
                                                  imageUrl: blog['authorPhotoUrl'],
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
                                            trailing: GestureDetector(
                                                onTap: (){
                                                  deleteBlog(blog['id']);
                                                },
                                                child: Icon(Icons.delete_forever,color: Colors.red.shade700,size: 35,)),
                                          ),

                                        ),
                                      );
                                    },
                                  );
                                }
                              },
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

  Future<void> deleteBlog(String blogID) async {
    final model = context.read<UserModel>();
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentReference userRef = firestore.collection('users').doc(model.id);

      DocumentReference blogRef = firestore.collection('blogs').doc(blogID);

      await blogRef.delete();

      await userRef.update({
        'blogs': FieldValue.arrayRemove([blogID])
      });
      setState(() {
        model.blogs.removeWhere((id) => id == blogID);
        userBlogs = fetchUserBlogs(model.blogs);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Blog deleted successfully!'),
            backgroundColor: Colors.red.shade600,
          ),
        );
      });

      print('Blog deleted successfully');
    } catch (e) {
      print('Error deleting blog: $e');
    }
  }
}
