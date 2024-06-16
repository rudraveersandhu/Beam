import 'package:flutter/material.dart';

class ReadBlog extends StatefulWidget {
  final String blog_title;
  final String blog_content;
  final String blog_author;
  final String blog_date;
  final String blog_author_url;

   ReadBlog({
    super.key,
    required this.blog_title,
    required this.blog_content,
    required this.blog_author,
    required this.blog_date,
    required this.blog_author_url,
  });

  @override
  State<ReadBlog> createState() => _ReadBlogState();
}

class _ReadBlogState extends State<ReadBlog> {
  @override
  Widget build(BuildContext context) {

    double screen_width = MediaQuery.of(context).size.width;

    if(screen_width > 500){
      screen_width = 500;
      return Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SafeArea(
            child: Center(
              child: Container(
                width: screen_width,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Navigator.pop(context);
                                },
                                child: Icon(Icons.arrow_back,
                                  color: Colors.grey.shade700,
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(right: 100.0),
                                child: Column(
                                  children: [
                                    Center(
                                      child: Text('Read Blogs and Discover',
                                        style: TextStyle(
                                            fontSize: 21,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.grey.shade800
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    const Center(
                                      child: Text('Read and Watch!',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 40),
                                  ],),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  widget.blog_title,
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.grey.shade800
                                  ),
                                ),
                              ),
                              SizedBox(height: 30),
                              Row(
                                children: [
                                  SizedBox(width: 5,),
                                  Container(
                                    //height: MediaQuery.of(context).size.height,
                                    width: screen_width - 50,
                                    child: Text(
                                      widget.blog_content,
                                      softWrap: true,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5,),
                                ],
                              ),
                            ],
                          ),


                        ],
                      ),
                      SizedBox(height: 50,),
                      Center(
                        child: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(widget.blog_author_url), // Ensure you have a profile image in your assets
                        ),
                      ),
                      SizedBox(height: 10,),
                      Center(
                        child: Text(
                          widget.blog_author,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          "On : ${widget.blog_date}",
                          style: TextStyle(
                              fontSize: 13,
                              //fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),

                      Container(height: MediaQuery.of(context).size.height,)


                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } else{
      return Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SafeArea(
            child: Center(
              child: Container(
                width: screen_width,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Navigator.pop(context);
                                },
                                child: Icon(Icons.arrow_back,
                                  color: Colors.grey.shade700,
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(right: 100.0),
                                child: Column(
                                  children: [
                                    Center(
                                      child: Text('Read Blogs and Discover',
                                        style: TextStyle(
                                            fontSize: 21,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.grey.shade800
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    const Center(
                                      child: Text('Read and Watch!',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 40),
                                  ],),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  widget.blog_title,
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.grey.shade800
                                  ),
                                ),
                              ),
                              SizedBox(height: 30),
                              Row(
                                children: [
                                  SizedBox(width: 5,),
                                  Container(
                                    //height: MediaQuery.of(context).size.height,
                                    width: screen_width - 50,
                                    child: Text(
                                      widget.blog_content,
                                      softWrap: true,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5,),
                                ],
                              ),
                            ],
                          ),


                        ],
                      ),
                      SizedBox(height: 50,),
                      Center(
                        child: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(widget.blog_author_url), // Ensure you have a profile image in your assets
                        ),
                      ),
                      SizedBox(height: 10,),
                      Center(
                        child: Text(
                          widget.blog_author,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          "On : ${widget.blog_date}",
                          style: TextStyle(
                              fontSize: 13,
                              //fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),

                      Container(height: MediaQuery.of(context).size.height,)


                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

  }


}
