import 'package:beam/auth_screens/start_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../utility_screens/my_blogs.dart';

class CancerCare extends StatefulWidget {


  const CancerCare({super.key});

  @override
  State<CancerCare> createState() => _CancerCareState();
}


class _CancerCareState extends State<CancerCare> {
  @override
  Widget build(BuildContext context) {
    double screen_width = MediaQuery.of(context).size.width;
    final model = context.read<UserModel>();

    if(screen_width > 500){
      screen_width = 500;
      return Scaffold(
        extendBody: false,
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              color: Colors.white,
              width: screen_width,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Good Morning ',
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                  Text(
                                    "${model.name} !",
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 2),
                              Text('Hope you’re doing fine!',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0,right: 4),
                            child: Icon(Icons.notifications_none, color: Colors.grey),
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text('Breast Cancer Support',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              color: Colors.grey.shade800
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Stack(
                        children: [
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width - 150,
                              child: CarouselSlider(
                                  items: getItems(),
                                  options: CarouselOptions(
                                    height: 170,
                                    aspectRatio: 16/9,
                                    viewportFraction: 1,
                                    initialPage: 0,
                                    enableInfiniteScroll: true,
                                    reverse: false,
                                    autoPlay: true,
                                    autoPlayInterval: Duration(seconds: 3),
                                    autoPlayAnimationDuration: Duration(milliseconds: 1000),
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    enlargeCenterPage: true,
                                    enlargeFactor: 1,
                                    //onPageChanged: callbackFunction,
                                    scrollDirection: Axis.horizontal,
                                  )
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width - 150,
                              height: 170,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.pinkAccent.withOpacity(0.2),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0,bottom: 5),
                        child: Text('Chemotherapy Session',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: Colors.grey.shade800

                          ),),
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 100),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(5, (index) {
                            return Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: index == 4 ? Colors.pink.shade300 : Colors.red.shade100,
                              ),
                              child: Center(
                                child: Text(
                                  '${12 + index}',
                                  style: TextStyle(color: index == 4 ? Colors.white : Colors.pinkAccent),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      SizedBox(height: 30),
                      Center(
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (builder) => const MyBlogs()));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width - 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(Icons.book, color: Colors.pink),
                                SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('My blogs',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.shade800,
                                          fontSize: 15
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text('A Collection of your written blogs',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.grey.shade500,
                                          fontSize: 12
                                      ),),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(height: MediaQuery.of(context).size.height),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }else{
      return Scaffold(
        extendBody: false,
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              color: Colors.white,
              width: screen_width,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Good Morning ',
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                  Text(
                                    "${model.name} !",
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 2),
                              Text('Hope you’re doing fine!',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0,right: 4),
                            child: Icon(Icons.notifications_none, color: Colors.grey),
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text('Breast Cancer Support',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              color: Colors.grey.shade800
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Stack(
                        children: [
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width - 150,
                              child: CarouselSlider(
                                  items: getItems(),
                                  options: CarouselOptions(
                                    height: 170,
                                    aspectRatio: 16/9,
                                    viewportFraction: 1,
                                    initialPage: 0,
                                    enableInfiniteScroll: true,
                                    reverse: false,
                                    autoPlay: true,
                                    autoPlayInterval: Duration(seconds: 3),
                                    autoPlayAnimationDuration: Duration(milliseconds: 1000),
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    enlargeCenterPage: true,
                                    enlargeFactor: 1,
                                    //onPageChanged: callbackFunction,
                                    scrollDirection: Axis.horizontal,
                                  )
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width - 150,
                              height: 170,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.pinkAccent.withOpacity(0.2),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0,bottom: 5),
                        child: Text('Chemotherapy Session',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: Colors.grey.shade800

                          ),),
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 100),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(5, (index) {
                            return Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: index == 4 ? Colors.pink.shade300 : Colors.red.shade100,
                              ),
                              child: Center(
                                child: Text(
                                  '${12 + index}',
                                  style: TextStyle(color: index == 4 ? Colors.white : Colors.pinkAccent),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      SizedBox(height: 30),
                      Center(
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (builder) => const MyBlogs()));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width - 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(Icons.book, color: Colors.pink),
                                SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('My blogs',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.shade800,
                                          fontSize: 15
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text('A Collection of your written blogs',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.grey.shade500,
                                          fontSize: 12
                                      ),),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(height: MediaQuery.of(context).size.height),
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

  getItems(){
    List<Widget> items = [
      Container(
        width: MediaQuery.of(context).size.width - 50,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Image.asset(
            'assets/img1.jpg',
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width - 50,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Image.asset(
            'assets/img2.jpg',
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width - 50,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Image.asset(
            'assets/img3.jpg',
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width - 50,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Image.asset(
            'assets/img4.jpg',
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width - 50,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Image.asset(
            'assets/img5.jpg',
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width - 50,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Image.asset(
            'assets/img6.jpg',
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width - 50,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Image.asset(
            'assets/img7.jpg',
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
    ];
    return items;
  }
}
