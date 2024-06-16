import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {

  int _counter = 0;

  @override
  void initState() {
    // TODO: implement initState
    FirebaseFirestore.instance.collection('visits').doc('counter').snapshots().listen((docSnapshot) {
      if (docSnapshot.exists) {
        // Update the counter when the document changes
        setState(() {
          _counter = docSnapshot.data()?['count'] ?? 0;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screen_width = MediaQuery.of(context).size.width;
    if(screen_width > 500){
      screen_width = 500;
      return Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              color: Colors.white,
              width: screen_width,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back),
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                },
                              ),
                              Icon(Icons.notifications_none, color: Colors.grey),
                            ],
                          ),
                          SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Beam Visitor's counter",
                                style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.grey.shade800
                                ),
                              ),

                            ],
                          ),
                          Text("See the number of app visits, worldwide and live!",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600),),
                          SizedBox(
                            height: 40,
                          ),
                          Text("Live Counter:",
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: Colors.grey.shade700),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width - 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20), // Adjust the value for desired curvature
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                  spreadRadius: 2, // How much the shadow spreads
                                  blurRadius: 5, // How blurry the shadow is
                                  offset: Offset(0, 3), // Changes the position of the shadow
                                ),
                              ],
                            ),
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Stack(
                                      children: [
                                        const Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(right: 40,top: 20),
                                              child: SimpleCircularProgressBar(
                                                mergeMode: true,
                                                animationDuration: 2,
                                                maxValue: 100,
                                                progressColors: [
                                                  Colors.red,
                                                  Colors.deepOrange
                                                ],
                                                backColor: Colors.blueGrey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10.0,top: 30),
                                          child: SizedBox(
                                              height: 80,
                                              width: 80,
                                              child: Image.asset('assets/woman.png')),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 80.0,bottom: 20),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Total counts:",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                          AnimatedFlipCounter(
                                            value: _counter,
                                            duration: Duration(seconds: 1),
                                            curve: Curves.easeOut, // pass in a value like 2014
                                          )

                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),


                        ],
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height,
                      )
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
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              color: Colors.white,
              width: screen_width,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back),
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                },
                              ),
                              Icon(Icons.notifications_none, color: Colors.grey),
                            ],
                          ),
                          SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Beam Visitor's counter",
                                style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.grey.shade800
                                ),
                              ),

                            ],
                          ),
                          Text("See the number of app visits, worldwide and live!",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600),),
                          SizedBox(
                            height: 40,
                          ),
                          Text("Live Counter:",
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: Colors.grey.shade700),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width - 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20), // Adjust the value for desired curvature
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                  spreadRadius: 2, // How much the shadow spreads
                                  blurRadius: 5, // How blurry the shadow is
                                  offset: Offset(0, 3), // Changes the position of the shadow
                                ),
                              ],
                            ),
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Stack(
                                      children: [
                                        const Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(right: 40,top: 20),
                                              child: SimpleCircularProgressBar(
                                                mergeMode: true,
                                                animationDuration: 2,
                                                maxValue: 100,
                                                progressColors: [
                                                  Colors.red,
                                                  Colors.deepOrange
                                                ],
                                                backColor: Colors.blueGrey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10.0,top: 30),
                                          child: SizedBox(
                                              height: 80,
                                              width: 80,
                                              child: Image.asset('assets/woman.png')),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 80.0,bottom: 20),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Total counts:",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                          AnimatedFlipCounter(
                                            value: _counter,
                                            duration: Duration(seconds: 1),
                                            curve: Curves.easeOut, // pass in a value like 2014
                                          )

                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),


                        ],
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height,
                      )
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
