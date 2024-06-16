 import "package:flutter/material.dart";
import "package:hive_flutter/adapters.dart";
import "package:simple_circular_progress_bar/simple_circular_progress_bar.dart";


class Hydration extends StatefulWidget {
  final double water;
  const Hydration({
    super.key,
    required this.water,
  });

  @override
  State<Hydration> createState() => _HydrationState();
}

class _HydrationState extends State<Hydration> {

  late ValueNotifier<double> water;
  int track = 0;

  @override
  void initState() {
    // TODO: implement initState
    water = ValueNotifier(widget.water);
    super.initState();
  }

  @override
  void dispose() {
    water.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screen_width = MediaQuery.of(context).size.width;
    if(screen_width > 500){
      screen_width =500;
      return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
              child: Container(
                width: screen_width,
                color: Colors.blue.shade300,
                child: SafeArea(
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 25.0),
                            child: GestureDetector(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text("Hydration",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.w700
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 25.0),
                            child: Icon(Icons.notifications_none_outlined,
                              color: Colors.white,),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0,left: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ValueListenableBuilder<double>(
                              valueListenable: water,
                              builder: (BuildContext context, double counterValue, Widget? child) {
                                // Update track variable here
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  setState(() {
                                    track = counterValue.toInt();
                                    updateWaterRecord(counterValue);
                                  });
                                });

                                return SimpleCircularProgressBar(
                                  valueNotifier: water,
                                  mergeMode: true,
                                  size: 150,
                                  animationDuration: 1,
                                  maxValue: 3000,
                                  progressColors: [
                                    Colors.white,
                                    Colors.white
                                  ],
                                  backColor: Colors.blueGrey,
                                  onGetText: (double value) {
                                    return Text(
                                      '${value.toInt() / 1000} L',
                                      style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            SizedBox(width: 30,),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 60.0),
                                  child: Container(
                                    height: 60,
                                    width: 140,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15), // Adjust the value for desired curvature
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                          spreadRadius: 2, // How much the shadow spreads
                                          blurRadius: 5, // How blurry the shadow is
                                          offset: Offset(0, 3), // Changes the position of the shadow
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: track > 3000 ? const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        //crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "     Target \nCompleted!",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color: Colors.blueAccent,
                                            ),
                                          ),
                                        ],
                                      ) : Text(
                                        "${((track / 3000) * 100).toStringAsFixed(2)}% Done",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),

                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  height: 60,
                                  width: 130,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15), // Adjust the value for desired curvature
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                        spreadRadius: 2, // How much the shadow spreads
                                        blurRadius: 5, // How blurry the shadow is
                                        offset: Offset(0, 3), // Changes the position of the shadow
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text("Target: 3L",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color: Colors.grey.shade700

                                      ),),
                                  ),
                                ),

                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      GestureDetector(
                          onTap:()=>water.value= water.value+1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap:(){
                                  water.value = water.value + 1000;

                                },
                                child: Column(
                                  children: [
                                    Container(
                                        height: 40,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Colors.white,
                                        ),
                                        child: Center(child: Text("Drank a bottle"))),
                                    SizedBox(height: 2,),
                                    Text("1 Litre",style: TextStyle(color: Colors.white),)
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap:(){
                                  water.value = 0;
                                },
                                child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.white,
                                    ),
                                    child: Center(child: Icon(Icons.delete_outline))),
                              ),
                              GestureDetector(
                                onTap:(){
                                  water.value = water.value + 250;

                                },
                                child: Column(
                                  children: [
                                    Container(
                                        height: 40,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Colors.white,
                                        ),
                                        child: Center(child: Text("Drank a glass"))),
                                    SizedBox(height: 2,),
                                    Text("250 ml",style: TextStyle(color: Colors.white),)
                                  ],
                                ),
                              ),
                            ],
                          )
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Center(
              child: Container(
                width: screen_width,
                child: DraggableScrollableSheet(
                  initialChildSize: 0.50,
                  minChildSize: 0.50,
                  builder: (BuildContext context, ScrollController scrollController) {
                    return SingleChildScrollView(
                      controller: scrollController,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40) ,
                                topRight: Radius.circular(40)
                            ),
                          ),
                          child:  Padding(
                            padding: const EdgeInsets.only(top: 70,left: 40),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Reminders",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.grey.shade700),
                                ),
                                SizedBox(height: 20,),
                                Container(
                                  height: 60,
                                  width: 400,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20), // Adjust the value for desired curvature
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.06), // Shadow color with opacity
                                        spreadRadius: 3, // How much the shadow spreads
                                        blurRadius: 6, // How blurry the shadow is
                                        offset: Offset(1, 1), // Changes the position of the shadow
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text('Compleate you daily water target'
                                        '!',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: Colors.grey.shade700
                                      ),),
                                  ),
                                ),
                                SizedBox(height: 20,),
                                Container(
                                  height: 60,
                                  width: 400,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20), // Adjust the value for desired curvature
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.06), // Shadow color with opacity
                                        spreadRadius: 3, // How much the shadow spreads
                                        blurRadius: 6, // How blurry the shadow is
                                        offset: Offset(1, 1), // Changes the position of the shadow
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text('Drink water'
                                        '!',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: Colors.grey.shade700
                                      ),),
                                  ),
                                ),
                                SizedBox(height: 20,),
                                /*Text("Statistics",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.grey.shade700),
                              ),*/
                              ],
                            ),
                          )
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }else{
      return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
              child: Container(
                width: screen_width,
                color: Colors.blue.shade300,
                child: SafeArea(
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 25.0),
                            child: GestureDetector(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text("Hydration",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.w700
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 25.0),
                            child: Icon(Icons.notifications_none_outlined,
                              color: Colors.white,),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0,left: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ValueListenableBuilder<double>(
                              valueListenable: water,
                              builder: (BuildContext context, double counterValue, Widget? child) {
                                // Update track variable here
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  setState(() {
                                    track = counterValue.toInt();
                                    updateWaterRecord(counterValue);
                                  });
                                });

                                return SimpleCircularProgressBar(
                                  valueNotifier: water,
                                  mergeMode: true,
                                  size: 150,
                                  animationDuration: 1,
                                  maxValue: 3000,

                                  progressColors: [
                                    Colors.white,
                                    Colors.white
                                  ],
                                  backColor: Colors.blueGrey,
                                  onGetText: (double value) {
                                    return Text(
                                      '${value.toInt() / 1000} L',
                                      style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            SizedBox(width: 30,),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 60.0),
                                  child: Container(
                                    height: 60,
                                    width: 140,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15), // Adjust the value for desired curvature
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                          spreadRadius: 2, // How much the shadow spreads
                                          blurRadius: 5, // How blurry the shadow is
                                          offset: Offset(0, 3), // Changes the position of the shadow
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: track > 3000 ? const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        //crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "     Target \nCompleted!",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color: Colors.blueAccent,
                                            ),
                                          ),
                                        ],
                                      ) : Text(
                                        "${((track / 3000) * 100).toStringAsFixed(2)}% Done",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),

                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  height: 60,
                                  width: 130,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15), // Adjust the value for desired curvature
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                        spreadRadius: 2, // How much the shadow spreads
                                        blurRadius: 5, // How blurry the shadow is
                                        offset: Offset(0, 3), // Changes the position of the shadow
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text("Target: 3L",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color: Colors.grey.shade700

                                      ),),
                                  ),
                                ),

                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      GestureDetector(
                          onTap:()=>water.value= water.value+1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap:(){
                                  water.value = water.value + 1000;

                                },
                                child: Column(
                                  children: [
                                    Container(
                                        height: 40,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Colors.white,
                                        ),
                                        child: Center(child: Text("Drank a bottle"))),
                                    SizedBox(height: 2,),
                                    Text("1 Litre",style: TextStyle(color: Colors.white),)
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap:(){
                                  water.value = 0;
                                },
                                child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.white,
                                    ),
                                    child: Center(child: Icon(Icons.delete_outline))),
                              ),
                              GestureDetector(
                                onTap:(){
                                  water.value = water.value + 250;

                                },
                                child: Column(
                                  children: [
                                    Container(
                                        height: 40,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Colors.white,
                                        ),
                                        child: Center(child: Text("Drank a glass"))),
                                    SizedBox(height: 2,),
                                    Text("250 ml",style: TextStyle(color: Colors.white),)
                                  ],
                                ),
                              ),
                            ],
                          )
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Center(
              child: Container(
                width: screen_width,
                child: DraggableScrollableSheet(
                  initialChildSize: 0.50,
                  minChildSize: 0.50,
                  builder: (BuildContext context, ScrollController scrollController) {
                    return SingleChildScrollView(
                      controller: scrollController,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40) ,
                                topRight: Radius.circular(40)
                            ),
                          ),
                          child:  Padding(
                            padding: const EdgeInsets.only(top: 70,left: 40),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Reminders",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.grey.shade700),
                                ),
                                SizedBox(height: 20,),
                                Container(
                                  height: 60,
                                  width: 400,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20), // Adjust the value for desired curvature
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.06), // Shadow color with opacity
                                        spreadRadius: 3, // How much the shadow spreads
                                        blurRadius: 6, // How blurry the shadow is
                                        offset: Offset(1, 1), // Changes the position of the shadow
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text('Compleate you daily water target'
                                        '!',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: Colors.grey.shade700
                                      ),),
                                  ),
                                ),
                                SizedBox(height: 20,),
                                Container(
                                  height: 60,
                                  width: 400,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20), // Adjust the value for desired curvature
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.06), // Shadow color with opacity
                                        spreadRadius: 3, // How much the shadow spreads
                                        blurRadius: 6, // How blurry the shadow is
                                        offset: Offset(1, 1), // Changes the position of the shadow
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text('Drink water'
                                        '!',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: Colors.grey.shade700
                                      ),),
                                  ),
                                ),
                                SizedBox(height: 20,),
                                /*Text("Statistics",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.grey.shade700),
                              ),*/
                              ],
                            ),
                          )
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }

  }
  updateWaterRecord(double x) async {
    final box = await Hive.openBox('Hydration');
    var water = await box.get('water') ?? double;
    water = x;
    await box.put('water', water);
  }
}
