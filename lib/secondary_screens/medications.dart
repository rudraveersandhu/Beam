import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:hive_flutter/adapters.dart";

class Medication extends StatefulWidget {
  final List<List<dynamic>> records;

  const Medication({
    Key? key,
    required this.records,
  }) : super(key: key);

  @override
  State<Medication> createState() => _MedicationState();
}

class _MedicationState extends State<Medication> {
  TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screen_width = MediaQuery.of(context).size.width;
    if(screen_width > 500){
      screen_width = 500;
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Container(
            width: screen_width,
            color: Colors.white,
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  //height: 400,
                  color: Colors.greenAccent.shade700,
                  //height: MediaQuery.of(context).size.height/2,
                  child: SafeArea(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
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
                            Text("Medications",
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
                        SizedBox(
                          height: 50,
                        ),
                        Center(
                          child: Icon(Icons.medical_information,
                            color: Colors.white,
                            size: 150,),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  child: DraggableScrollableSheet(
                    initialChildSize: 0.55,
                    minChildSize: 0.55,
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
                            child:  Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding:  EdgeInsets.only(top: 20.0,right: 20),
                                      child: Center(
                                        child: GestureDetector(
                                          onTap: (){
                                            addMed();

                                          },
                                          child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(25),
                                                color: Colors.greenAccent.shade700,
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.all(15.0),
                                                child: Text("Add Medicine Schedule",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w700
                                                  ),),
                                              )),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20,right: 30),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 30.0),
                                        child: Text("Medication Reminders",
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.grey.shade700),
                                        ),
                                      ),
                                      SizedBox(height: 20,),
                                      Container(
                                        height: 100 * widget.records.length.toDouble(),
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: widget.records.length,
                                          padding: EdgeInsets.zero,
                                          itemBuilder: (context, index) {
                                            print(widget.records.length);
                                            if(widget.records.length > 0){
                                              return Padding(
                                                padding: const EdgeInsets.only(left: 40.0, right: 40, bottom: 20),
                                                child: Container(
                                                  height: 60,
                                                  width: MediaQuery.of(context).size.width - 100,
                                                  decoration: BoxDecoration(
                                                    color: Colors.green.shade100,
                                                    borderRadius: BorderRadius.circular(20),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black.withOpacity(0.06),
                                                        spreadRadius: 3,
                                                        blurRadius: 6,
                                                        offset: Offset(1, 1),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                                                    child: Center(
                                                      child: Text(
                                                        widget.records[index][1].toString(),
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 17,
                                                            color: Colors.grey.shade700),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            } else if (widget.records.length == 0){
                                              print("ghchjxjucj");
                                              return Padding(
                                                padding: const EdgeInsets.only(left: 40.0, right: 40, bottom: 20),
                                                child: Container(
                                                  height: 60,
                                                  width: MediaQuery.of(context).size.width - 300,
                                                  decoration: BoxDecoration(
                                                    color: Colors.orange,
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
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                                                    child: Center(
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            "No medical Schedule for now.",
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: 14,
                                                                color: Colors.grey.shade700),
                                                          ),
                                                          Text(
                                                            widget.records[index][1],
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: 14,
                                                                color: Colors.grey.shade700),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                            return Container(width: 300,height: 30,color: Colors.red,);
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 20,),
                                    ],
                                  ),
                                ),
                              ],
                            )
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Container(
            width: screen_width,
            color: Colors.white,
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  //height: 400,
                  color: Colors.greenAccent.shade700,
                  //height: MediaQuery.of(context).size.height/2,
                  child: SafeArea(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
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
                            Text("Medications",
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
                        SizedBox(
                          height: 50,
                        ),
                        Center(
                          child: Icon(Icons.medical_information,
                            color: Colors.white,
                            size: 150,),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  child: DraggableScrollableSheet(
                    initialChildSize: 0.55,
                    minChildSize: 0.55,
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
                            child:  Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding:  EdgeInsets.only(top: 20.0,right: 20),
                                      child: Center(
                                        child: GestureDetector(
                                          onTap: (){
                                            addMed();

                                          },
                                          child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(25),
                                                color: Colors.greenAccent.shade700,
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.all(15.0),
                                                child: Text("Add Medicine Schedule",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w700
                                                  ),),
                                              )),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20,right: 30),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 30.0),
                                        child: Text("Medication Reminders",
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.grey.shade700),
                                        ),
                                      ),
                                      SizedBox(height: 20,),
                                      Container(
                                        height: 100 * widget.records.length.toDouble(),
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: widget.records.length,
                                          padding: EdgeInsets.zero,
                                          itemBuilder: (context, index) {
                                            print(widget.records.length);
                                            if(widget.records.length > 0){
                                              return Padding(
                                                padding: const EdgeInsets.only(left: 40.0, right: 40, bottom: 20),
                                                child: Container(
                                                  height: 60,
                                                  width: MediaQuery.of(context).size.width - 100,
                                                  decoration: BoxDecoration(
                                                    color: Colors.green.shade100,
                                                    borderRadius: BorderRadius.circular(20),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black.withOpacity(0.06),
                                                        spreadRadius: 3,
                                                        blurRadius: 6,
                                                        offset: Offset(1, 1),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                                                    child: Center(
                                                      child: Text(
                                                        widget.records[index][1].toString(),
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 17,
                                                            color: Colors.grey.shade700),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            } else if (widget.records.length == 0){
                                              print("ghchjxjucj");
                                              return Padding(
                                                padding: const EdgeInsets.only(left: 40.0, right: 40, bottom: 20),
                                                child: Container(
                                                  height: 60,
                                                  width: MediaQuery.of(context).size.width - 300,
                                                  decoration: BoxDecoration(
                                                    color: Colors.orange,
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
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                                                    child: Center(
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            "No medical Schedule for now.",
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: 14,
                                                                color: Colors.grey.shade700),
                                                          ),
                                                          Text(
                                                            widget.records[index][1],
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: 14,
                                                                color: Colors.grey.shade700),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                            return Container(width: 300,height: 30,color: Colors.red,);
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 20,),
                                    ],
                                  ),
                                ),
                              ],
                            )
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }


  }

  addMed(){
    int dose = 0;
    String medicine = '';
    DateTime initDate = DateTime(1);
    DateTime lastDate = DateTime(1);

    return showDialog(
        context: context,
        builder: (BuildContext context) {

          DateTime startDate = DateTime.now();
          DateTime endDate = DateTime.now();
          return AlertDialog(
            title: Text('Add Medicines'),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      onChanged: (value){
                        medicine = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter Medicine name',
                      ),
                    ),
                    SizedBox(height: 16), // Add spacing between fields
                    Row(
                      children: <Widget>[
                        Text('Start Date:'),
                        SizedBox(width: 8),
                        GestureDetector(
                          onTap: () async {
                            final DateTime? pickedStartDate = await showDatePicker(
                              context: context,
                              initialDate: startDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2025),
                            );
                            if (pickedStartDate != null) {
                              setState(() {
                                initDate = pickedStartDate;
                                startDate = pickedStartDate;
                              });
                            }
                          },
                          child: Container(
                            height: 40,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.green,
                            ),

                            child: Center(child: Text('${startDate.day} : ${startDate.month} : ${startDate.year}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700
                            ),
                            )),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        Text('End Date:'),
                        SizedBox(width: 8),
                        GestureDetector(
                          onTap: () async {
                            final DateTime? pickedEndDate = await showDatePicker(
                              context: context,
                              initialDate: endDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2025),
                            );
                            if (pickedEndDate != null) {
                              setState(() {
                                lastDate = pickedEndDate;
                                endDate = pickedEndDate;
                              });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Container(
                              height: 40,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: Colors.green,
                              ),

                              child: Center(child: Text('${endDate.day} : ${endDate.month} : ${endDate.year}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700
                                ),
                              )),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Text('Dose per day:'),
                    TextField(
                      keyboardType: TextInputType.number,

                      onChanged: (value){
                        dose = int.parse(value);
                        print("dose: $dose");
                      },
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                      hintText: 'Enter doses per day: eg: 2',
                      ),
                    ),

                  ],
                );
              },
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              GestureDetector(
                onTap: () {
                  if (dose >0 && medicine != '' && initDate != DateTime(1) && lastDate != DateTime(1)) {
                    final snackBar = SnackBar(
                      backgroundColor: Colors.green,
                      content: const Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Schedule Added Sucessfully!',
                            style: TextStyle(
                              color: Colors.white,
                                fontSize: 18
                            ),),
                        ],
                      )),
                      action: SnackBarAction(
                        label: 'Close',
                        onPressed: () {
                          // Some code to undo the change.
                        },
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    setState(() {
                      saveMedic(dose,medicine,initDate,lastDate);
                      List<dynamic> dum = [dose,medicine,initDate,lastDate];
                      widget.records.add(dum);
                    });
                    Navigator.of(context).pop();
                  } else {
                    final snackBar = SnackBar(
                      backgroundColor: Colors.red,
                      content: const Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Add all the parameters!',
                          style: TextStyle(
                            fontSize: 18
                          ),),
                        ],
                      )),
                      action: SnackBarAction(
                        label: 'Close',
                        onPressed: () {
                          // Some code to undo the change.
                        },
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: Text('Add'),
              ),
            ],
          );
        },
    );
  }

  saveMedic(int dosage, String med, DateTime init, DateTime last) async {
    final box = await Hive.openBox('Medical');

    var dose = await box.get('dose') ?? <int>[];
    var medicine = await box.get('medicine') ?? <String>[];
    var initDate = await box.get('initDate') ?? <DateTime>[];
    var lastDate = await box.get('lastDate') ?? <DateTime>[];

    dose.add(dosage);
    medicine.add(med);
    initDate.add(init);
    lastDate.add(last);

    await box.put('dose', dose);
    await box.put('medicine', medicine);
    await box.put('initDate', initDate);
    await box.put('lastDate', lastDate);

    print("Stored to Hive successfully");
  }
}
