import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utility_screens/new_blog.dart';
import '../utility_screens/readblog.dart';

class SearchBlogs extends StatefulWidget {
  const SearchBlogs({super.key});

  @override
  State<SearchBlogs> createState() => _SearchBlogsState();
}

class _SearchBlogsState extends State<SearchBlogs> {
  String searchQuery = '';
  List<Map<String, dynamic>> filteredBlogs = [];
  final ScrollController _scrollController = ScrollController();

  bool focused = false;

  void _filterBlogs(String query) async {
    var blogsQuery = await FirebaseFirestore.instance.collection('blogs').get();
    var filteredList = blogsQuery.docs.where((doc) {
      var title = doc['title'].toString().toLowerCase();
      return title.contains(query);
    }).toList();

    setState(() {
      filteredBlogs = filteredList.map((doc) => doc.data()).toList();
      if(query == ''){
        filteredBlogs =[];
      }
    });
  }

  // convertTime(Timestamp timestamp){
  //   DateTime dateTime = timestamp.toDate();
  //   String formattedTime = DateFormat('hh:mm a').format(dateTime);
  //   return formattedTime;
  // }
  //
  // convertDate(DateTime dateTime){
  //   String date = "${dateTime.day}-${dateTime.month}-${dateTime.year}";
  //   return date;
  // }


  @override
  Widget build(BuildContext context) {
    double screen_width = MediaQuery.of(context).size.width;

    if(screen_width > 500){

      return Scaffold(
        //extendBody: true,
        backgroundColor: Colors.black,
        body: SingleChildScrollView(

          //scrollDirection: Axis.vertical,
          //controller: _scrollController,
          child: Center(
            child: Container(
              color: Colors.white,
              width: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0,right: 16.0,top: 16.0),
                                  child: Text('Search Blogs and Discover',
                                    style: TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.grey.shade800

                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0,right: 16.0),
                                  child: const Text('Explore and Learn!',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20.0,top: 1),
                              child: Icon(Icons.notifications_none, color: Colors.grey),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.pinkAccent,
                            ),
                            width: MediaQuery.of(context).size.width - 50,

                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Search Bar
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: TextField(
                                decoration: InputDecoration(
                                  labelText: 'Search Blogs by Title',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.search),
                                ),
                                onChanged: (value) async {
                                  setState(() {
                                    searchQuery = value.toLowerCase();
                                    if(value == ''){
                                      _filterBlogs('');
                                    }
                                  });
                                  _filterBlogs(searchQuery);
                                },
                              ),
                            ),
                            // Search Results
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15.0,left: 30),
                                      child: Text('Top Blogs',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.grey.shade800
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20.0,right: 15),
                                      child: Center(
                                        child: Column(
                                          children: [
                                            GestureDetector(
                                              onTap: (){
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) =>  NewBlog()),
                                                );
                                              },
                                              child: Container(
                                                height: 35,
                                                width: 110,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
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
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(CupertinoIcons.pencil,color: Colors.grey.shade500,),
                                                    Text("Write a blog",style: TextStyle(color: Colors.grey.shade700,fontSize: 12),),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),


                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                Container(
                                  height: MediaQuery.of(context).size.height,
                                  child: StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection('blogs').snapshots(),
                                    builder: (context, snapshot) {

                                      if (!snapshot.hasData) {return Center(child: CircularProgressIndicator());}

                                      var blogs = snapshot.data!.docs;

                                      return ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),

                                        scrollDirection: Axis.vertical,
                                        itemCount: blogs.length,
                                        itemBuilder: (context, index) {
                                          var blog = blogs[index];
                                          var blogTitle = blog['title'];
                                          var blogContent = blog['content'];
                                          var blogAuthor = blog['authorName'];
                                          //var blogDate = "${convertDate(blog['timestamp'].toDate())}   \n At : ${convertTime(blog['timestamp'])}";
                                          var blogAuthorPhotoUrl = blog['authorPhotoUrl'];

                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => ReadBlog(
                                                    blog_title: blogTitle,
                                                    blog_content: blogContent,
                                                    blog_author: blogAuthor,
                                                    //blog_date: blogDate,
                                                    blog_author_url: blogAuthorPhotoUrl,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 15.0,left: 30,right: 30),
                                                child: Container(
                                                  height: MediaQuery.of(context).size.height/12,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(20),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black.withOpacity(0.1),
                                                        spreadRadius: 3,
                                                        blurRadius: 6,
                                                        offset: Offset(1, 1),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(10.0),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            CircleAvatar(
                                                              radius: 20,
                                                              backgroundImage: blogAuthorPhotoUrl != null
                                                                  ? NetworkImage(blogAuthorPhotoUrl)
                                                                  : AssetImage('assets/user.png'),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 10.0),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Container(
                                                                    width: 350,
                                                                    child: Text(
                                                                      blogTitle,
                                                                      style: TextStyle(
                                                                        fontWeight: FontWeight.w800,
                                                                        fontSize: 14,
                                                                        color: Colors.grey.shade700,

                                                                      ),
                                                                        overflow: TextOverflow.ellipsis
                                                                    ),
                                                                  ),

                                                                  SizedBox(width: 10),
                                                                  Text("Author: $blogAuthor"),
                                                                ],
                                                              ),
                                                            ),
                                                            // Padding(
                                                            //   padding: const EdgeInsets.only(right: 8.0),
                                                            //   child: Text(
                                                            //     "On: ${convertDate(blog['timestamp'].toDate())}",
                                                            //     style: TextStyle(
                                                            //       fontWeight: FontWeight.w500,
                                                            //       color: Colors.grey.shade700,
                                                            //     ),
                                                            //   ),
                                                            // ),
                                                          ],
                                                        ),
                                                        // SizedBox(height: 5),
                                                        //
                                                        // SizedBox(height: 5),
                                                        // Text(
                                                        //   blogContent,
                                                        //   style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                                                        //   overflow: TextOverflow.ellipsis,
                                                        //   maxLines: 4,
                                                        // ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    for (var blog in filteredBlogs)
                                      GestureDetector(
                                        onTap: () async {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ReadBlog(
                                                blog_title: blog['title'],
                                                blog_content: blog['content'],
                                                blog_author: blog['authorName'],
                                                //blog_date: "${convertDate(blog['timestamp'].toDate())}   \n At : ${convertTime(blog['timestamp'])}",
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
                                            subtitle: Text('Author: ${blog['authorName']}'),
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
                                          ),

                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 150),

                      ],
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

          child: Center(
            child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                                  child: Text(
                                    'Search Blogs and Discover',
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                                  child: const Text(
                                    'Explore and Learn!',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20.0, top: 1),
                              child: Icon(Icons.notifications_none, color: Colors.grey),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.pinkAccent,
                            ),
                            width: MediaQuery.of(context).size.width - 50,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Search Bar
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: TextField(
                                decoration: InputDecoration(
                                  labelText: 'Search Blogs by Title',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.search),
                                ),
                                onChanged: (value) async {
                                  setState(() {
                                    searchQuery = value.toLowerCase();
                                    if (value == '') {
                                      _filterBlogs('');
                                    }
                                  });
                                  _filterBlogs(searchQuery);
                                },
                              ),
                            ),
                            // Search Results
                            Stack(
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 15.0,left: 30),
                                          child: Text('Top Blogs',
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.grey.shade800
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 20.0,right: 15),
                                          child: Center(
                                            child: Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: (){
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) =>  NewBlog()),
                                                    );
                                                  },
                                                  child: Container(
                                                    height: 35,
                                                    width: 110,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
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
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Icon(CupertinoIcons.pencil,color: Colors.grey.shade500,),
                                                        Text("Write a blog",style: TextStyle(color: Colors.grey.shade700,fontSize: 12),),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),


                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 15,),
                                    Container(
                                      height: MediaQuery.of(context).size.height,
                                      child: StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance.collection('blogs').snapshots(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return Center(child: CircularProgressIndicator());
                                          }
                                          var blogs = snapshot.data!.docs;

                                          return ListView.builder(
                                            physics: NeverScrollableScrollPhysics(),
                                            scrollDirection: Axis.vertical,
                                            itemCount: blogs.length,
                                            itemBuilder: (context, index) {
                                              var blog = blogs[index];
                                              var blogTitle = blog['title'];
                                              var blogContent = blog['content'];
                                              var blogAuthor = blog['authorName'];
                                              var blogAuthorPhotoUrl = blog['authorPhotoUrl'];

                                              return GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => ReadBlog(
                                                        blog_title: blogTitle,
                                                        blog_content: blogContent,
                                                        blog_author: blogAuthor,
                                                        blog_author_url: blogAuthorPhotoUrl,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 15.0,left: 30,right: 30),
                                                    child: Container(
                                                      height: MediaQuery.of(context).size.height/12,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(20),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black.withOpacity(0.1),
                                                            spreadRadius: 3,
                                                            blurRadius: 6,
                                                            offset: Offset(1, 1),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(10.0),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                                CircleAvatar(
                                                                  radius: 20,
                                                                  backgroundImage: blogAuthorPhotoUrl != null
                                                                      ? NetworkImage(blogAuthorPhotoUrl)
                                                                      : AssetImage('assets/user.png'),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.only(left: 10.0),
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Container(
                                                                        width: MediaQuery.of(context).size.width * 0.65,
                                                                        child: Text(
                                                                            blogTitle,
                                                                            style: TextStyle(
                                                                              fontWeight: FontWeight.w800,
                                                                              fontSize: 14,
                                                                              color: Colors.grey.shade700,

                                                                            ),
                                                                            overflow: TextOverflow.ellipsis
                                                                        ),
                                                                      ),

                                                                      SizedBox(width: 10),
                                                                      Text("Author: $blogAuthor"),
                                                                    ],
                                                                  ),
                                                                ),
                                                                // Padding(
                                                                //   padding: const EdgeInsets.only(right: 8.0),
                                                                //   child: Text(
                                                                //     "On: ${convertDate(blog['timestamp'].toDate())}",
                                                                //     style: TextStyle(
                                                                //       fontWeight: FontWeight.w500,
                                                                //       color: Colors.grey.shade700,
                                                                //     ),
                                                                //   ),
                                                                // ),
                                                              ],
                                                            ),
                                                            // SizedBox(height: 5),
                                                            //
                                                            // SizedBox(height: 5),
                                                            // Text(
                                                            //   blogContent,
                                                            //   style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                                                            //   overflow: TextOverflow.ellipsis,
                                                            //   maxLines: 4,
                                                            // ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),

                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    for (var blog in filteredBlogs)
                                      GestureDetector(
                                        onTap: () async {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ReadBlog(
                                                blog_title: blog['title'],
                                                blog_content: blog['content'],
                                                blog_author: blog['authorName'],
                                                blog_author_url: blog['authorPhotoUrl'],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Card(
                                          color: Colors.pink.shade100.withBlue(1000).withGreen(1000).withRed(1022),
                                          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                                          elevation: 50,
                                          child: ListTile(
                                            title: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(blog['title']),
                                              ],
                                            ),
                                            subtitle: Text('Author: ${blog['authorName']}'),
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
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 150),
                      ],
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
}


//backup container design
// Container(
// height: 200,
// decoration: BoxDecoration(
// color: Colors.white,
// borderRadius: BorderRadius.circular(20),
// boxShadow: [
// BoxShadow(
// color: Colors.black.withOpacity(0.1),
// spreadRadius: 3,
// blurRadius: 6,
// offset: Offset(1, 1),
// ),
// ],
// ),
// child: Padding(
// padding: const EdgeInsets.all(10.0),
// child: Column(
// mainAxisAlignment: MainAxisAlignment.start,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Row(
// children: [
// CircleAvatar(
// radius: 20,
// backgroundImage: blogAuthorPhotoUrl != null
// ? NetworkImage(blogAuthorPhotoUrl)
//     : AssetImage('assets/user.png'),
// ),
// SizedBox(width: 10),
// Text(blogAuthor),
// ],
// ),
// // Padding(
// //   padding: const EdgeInsets.only(right: 8.0),
// //   child: Text(
// //     "On: ${convertDate(blog['timestamp'].toDate())}",
// //     style: TextStyle(
// //       fontWeight: FontWeight.w500,
// //       color: Colors.grey.shade700,
// //     ),
// //   ),
// // ),
// ],
// ),
// SizedBox(height: 5),
// Text(
// blogTitle,
// style: TextStyle(
// fontWeight: FontWeight.w800,
// fontSize: 14,
// color: Colors.grey.shade700,
// ),
// ),
// SizedBox(height: 5),
// Text(
// blogContent,
// style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
// overflow: TextOverflow.ellipsis,
// maxLines: 4,
// ),
// ],
// ),
// ),
// ),