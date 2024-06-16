import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/neat_and_clean_calendar_event.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:beam/secondary_screens/chemotherapy.dart';
import 'package:beam/secondary_screens/medications.dart';
import '../secondary_screens/hydration.dart';

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
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
                              Text(
                                "Health",
                                style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.grey.shade800
                                ),
                              ),
                              const Icon(Icons.notifications_none, color: Colors.grey),
                            ],
                          ),
                          const Text("Hope you're taking care of yourself!",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600),),
                          const SizedBox(
                            height: 40,
                          ),
                          Text("Health Tracker",
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: Colors.grey.shade700),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              double water = await getHydra();
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Hydration(water: water,)),
                              );
                            },
                            child: Container(
                              height: 150,
                              width: MediaQuery.of(context).size.width - 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 25),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Hydration",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                          Text("3 Litres daily",
                                            style: TextStyle(
                                                color: Colors.grey.shade700
                                            ),
                                          ),
                                        ],
                                      ),
                                      Stack(
                                        children: [
                                          const Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(right: 40,top: 20),
                                                child: SimpleCircularProgressBar(
                                                  animationDuration: 1,
                                                  maxValue: 100,
                                                  progressColors: [
                                                    Colors.blue,
                                                    Colors.blueAccent
                                                  ],
                                                  backColor: Colors.blueGrey,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 15.0,top: 30),
                                            child: SizedBox(
                                                height: 70,
                                                width: 70,
                                                child: Image.asset('assets/drop.png')),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
          
                          const SizedBox(height: 20,),
          
                          GestureDetector(
                            onTap: () async {
                              List<NeatCleanCalendarEvent> x = await getEvents();
                              List<ChemoData> planned_chem = await getChemo();
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>  Chemotherapy(events: x,chemo: planned_chem)),
                              );
                            },
                            child: Container(
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
                              child: Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Chemotherapy",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20,
                                              color: Colors.grey.shade700
                                          ),),
                                        Text("Sessions",
                                          style: TextStyle(
                                              color: Colors.grey.shade700
                                          ),),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 40,top: 20),
                                          child: SizedBox(
                                              height: 100,
                                              width: 100,
                                              child: Image.asset('assets/notepad.png')),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
          
                          const SizedBox(height: 20,),
          
                          GestureDetector(
                            onTap: () async {
                              List<List<dynamic>> records = await getMedic();
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>  Medication(records: records,)),
                              );
                            },
                            child: Container(
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
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Medication and \nSymptoms",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20,
                                                color: Colors.grey.shade700
                                            ),),
                                          Text("Ongoing Medications",
                                              style: TextStyle(
                                                  color: Colors.grey.shade700
                                              )),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 40,top: 20),
                                            child: SizedBox(
                                                height: 100,
                                                width: 100,
                                                child: Image.asset('assets/meds.png')),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
          
          
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
                              Text(
                                "Health",
                                style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.grey.shade800
                                ),
                              ),
                              const Icon(Icons.notifications_none, color: Colors.grey),
                            ],
                          ),
                          const Text("Hope you're taking care of yourself!",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600),),
                          const SizedBox(
                            height: 40,
                          ),
                          Text("Health Tracker",
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: Colors.grey.shade700),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              double water = await getHydra();
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Hydration(water: water,)),
                              );
                            },
                            child: Container(
                              height: 150,
                              width: MediaQuery.of(context).size.width - 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 25),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Hydration",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                          Text("3 Litres daily",
                                            style: TextStyle(
                                                color: Colors.grey.shade700
                                            ),
                                          ),
                                        ],
                                      ),
                                      Stack(
                                        children: [
                                          const Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(right: 40,top: 20),
                                                child: SimpleCircularProgressBar(
                                                  animationDuration: 1,
                                                  maxValue: 100,
                                                  progressColors: [
                                                    Colors.blue,
                                                    Colors.blueAccent
                                                  ],
                                                  backColor: Colors.blueGrey,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 15.0,top: 30),
                                            child: SizedBox(
                                                height: 70,
                                                width: 70,
                                                child: Image.asset('assets/drop.png')),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20,),

                          GestureDetector(
                            onTap: () async {
                              List<NeatCleanCalendarEvent> x = await getEvents();
                              List<ChemoData> planned_chem = await getChemo();
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>  Chemotherapy(events: x,chemo: planned_chem)),
                              );
                            },
                            child: Container(
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
                              child: Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Chemotherapy",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20,
                                              color: Colors.grey.shade700
                                          ),),
                                        Text("Sessions",
                                          style: TextStyle(
                                              color: Colors.grey.shade700
                                          ),),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 40,top: 20),
                                          child: SizedBox(
                                              height: 100,
                                              width: 100,
                                              child: Image.asset('assets/notepad.png')),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20,),

                          GestureDetector(
                            onTap: () async {
                              List<List<dynamic>> records = await getMedic();
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>  Medication(records: records,)),
                              );
                            },
                            child: Container(
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
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Medication and \nSymptoms",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20,
                                                color: Colors.grey.shade700
                                            ),),
                                          Text("Ongoing Medications",
                                              style: TextStyle(
                                                  color: Colors.grey.shade700
                                              )),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 40,top: 20),
                                            child: SizedBox(
                                                height: 100,
                                                width: 100,
                                                child: Image.asset('assets/meds.png')),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),


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

  getEvents() async {
    final box = await Hive.openBox('Events');
    var des = await box.get('des') ?? <String>[];
    var start = await box.get('start') ?? <DateTime>[];
    var end = await box.get('end') ?? <DateTime>[];

    List<NeatCleanCalendarEvent> events = [];

    for(int x = 0; x < des.length ; x++){

      events.add(
          NeatCleanCalendarEvent(
            'Chemo',
            description: des[x],
            startTime: start[x],
            endTime: end[x],
            color: Colors.green,
          ));
    }
    return events;
  }

  getChemo() async {
    final box = await Hive.openBox('Events');
    var des = await box.get('des') ?? <String>[];
    var start = await box.get('start') ?? <DateTime>[];
    var end = await box.get('end') ?? <DateTime>[];

    List<ChemoData> planned_chemo = [];


    for(int x = 0; x < des.length ; x++){
      planned_chemo.add(ChemoData(start[x]!, 1));
    }
    return planned_chemo;

  }

  getMedic() async {
    final box = await Hive.openBox('Medical');

    var dose = await box.get('dose') ?? <int>[];
    var medicine = await box.get('medicine') ?? <String>[];
    var initDate = await box.get('initDate') ?? <DateTime>[];
    var lastDate = await box.get('lastDate') ?? <DateTime>[];

    List<List<dynamic>> med = [];

    for(int x = 0; x < dose.length ; x++){
      List<dynamic> dum = [dose[x],medicine[x],initDate[x],lastDate[x]];
      med.add(dum);
    }

    return med;
  }

  Future<double> getHydra() async {
    final box = await Hive.openBox('Hydration');
    var water = await box.get('water') ?? 0.0;

    if (water is double) {
      return water;
    } else {
      throw Exception('Expected a double value for water');
    }
  }

}
