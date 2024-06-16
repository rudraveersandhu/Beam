
import "package:draggable_bottom_sheet/draggable_bottom_sheet.dart";
import "package:flutter/material.dart";
//import "package:flutter_datetime_picker/flutter_datetime_picker.dart";
import "package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart";
import "package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart";
import "package:hive_flutter/adapters.dart";
import "package:table_calendar/table_calendar.dart";
//import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Chemotherapy extends StatefulWidget {
  final List<NeatCleanCalendarEvent> events;
  final List<ChemoData> chemo;

  Chemotherapy({
    Key? key,
    required this.events, required this.chemo,
  }) : super(key: key);

  @override
  State<Chemotherapy> createState() => _ChemotherapyState();
}

class _ChemotherapyState extends State<Chemotherapy> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<NeatCleanCalendarEvent> events = [];
  final List<ChemoData> planned_chemo = [


  ];

  final List<ChemoData> attended_chemo = [

  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }



  addEvents(String note, DateTime str, DateTime en ) async {
    final box = await Hive.openBox('Events');
    var des = box.get('des') ?? <String>[];
    var start = box.get('start') ?? <DateTime>[];
    var end = box.get('end') ?? <DateTime>[];

    des.add(note);
    start.add(str);
    end.add(en);

    box.put('des', des);
    box.put('start', start);
    box.put('end', end);
    print("Stored to Hive successfully");



  }

  void _handleNewDate(DateTime date) {
    print('Date selected: $date');
  }

  void _handleNewEvent(NeatCleanCalendarEvent event) {
    print('Event selected: ${event.summary}');
  }


  @override

  Widget build(BuildContext context) {
    double screen_width = MediaQuery.of(context).size.width;
    if(screen_width > 500){
      screen_width = 500;
      return Material(
        color: Colors.black,
        child: Center(
          child: Container(
            width: screen_width,
            color: Colors.white,
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.pinkAccent,
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
                            Text("Chemotherapy",
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
                        SizedBox(height: 20,),
                        Container(
                          height: 350,
                          width: 340,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white.withOpacity(.9),
                          ),
                          child: Calendar(
                            startOnMonday: true,
                            weekDays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                            eventsList: widget.events,
                            isExpandable: true,
                            eventDoneColor: Colors.green,
                            selectedColor: Colors.pink,
                            selectedTodayColor: Colors.red,
                            todayColor: Colors.blue,
                            eventColor: Colors.orange,
                            locale: 'en_EN',
                            todayButtonText: '',
                            allDayEventText: 'Ganztägig',
                            multiDayEndText: 'Ende',
                            isExpanded: true,
                            expandableDateFormat: 'EEEE, dd. MMMM yyyy',
                            datePickerType: DatePickerType.date,
                            onDateSelected: _handleNewDate,
                            onEventSelected: _handleNewEvent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: DraggableScrollableSheet(
                    expand: true,
                    initialChildSize: 0.4,
                    minChildSize: 0.4,
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
                                          onTap: _addNewEvent,
                                          child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(25),
                                                color: Colors.pinkAccent,
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.all(15.0),
                                                child: Text("Add Chemo event",
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30.0,top: 30),
                                      child: Text("Chemotherapy Sessions",
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.grey.shade700),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 200,
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: widget.events.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(left: 40.0, right: 40,top: 20),
                                        child: GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              _showConfirmationDialog(context);
                                              attended_chemo.add(ChemoData(widget.events[index].startTime, 1),);
                                            });

                                          },
                                          child: Container(
                                            height: 60,
                                            width: MediaQuery.of(context).size.width - 300,
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
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      widget.events[index].description,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 14,
                                                          color: Colors.grey.shade700),
                                                    ),
                                                    Text(
                                                      widget.events[index].startTime.toString(),
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
                                        ),
                                      ); // <-- Removed the unnecessary space here
                                    },
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 30.0,top: 30),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [

                                      Text("Statistics",
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.grey.shade700),
                                      ),


                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                widget.chemo.length > 0 ?  Center(
                                    child: Container(
                                        child: SfCartesianChart(
                                            primaryXAxis: const CategoryAxis(),
                                            series: <CartesianSeries>[
                                              // Renders line chart
                                              LineSeries<ChemoData, DateTime>(
                                                dataSource: widget.chemo,
                                                xValueMapper: (ChemoData sales, _) => sales.date,
                                                yValueMapper: (ChemoData sales, _) => sales.attended+1,
                                              ),
                                              LineSeries<ChemoData, DateTime>(
                                                color: Colors.green,
                                                dataSource: attended_chemo,
                                                yValueMapper: (ChemoData sales, _) => sales.attended,
                                                xValueMapper: (ChemoData sales, _) => sales.date,
                                              )
                                            ]
                                        )
                                    )
                                ): Container(
                                  height: 30,
                                  width: 300,
                                  decoration: BoxDecoration(
                                      color: Colors.pinkAccent.shade100,
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Center(child: Text("Add a chemotherapy event for statistics",
                                    style: TextStyle(color: Colors.white),)),
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
      return Material(
        color: Colors.black,
        child: Center(
          child: Container(
            width: screen_width,
            color: Colors.white,
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.pinkAccent,
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
                            Text("Chemotherapy",
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
                        SizedBox(height: 20,),
                        Container(
                          height: 350,
                          width: 340,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white.withOpacity(.9),
                          ),
                          child: Calendar(
                            startOnMonday: true,
                            weekDays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                            eventsList: widget.events,
                            isExpandable: true,
                            eventDoneColor: Colors.green,
                            selectedColor: Colors.pink,
                            selectedTodayColor: Colors.red,
                            todayColor: Colors.blue,
                            eventColor: Colors.orange,
                            locale: 'en_EN',
                            todayButtonText: '',
                            allDayEventText: 'Ganztägig',
                            multiDayEndText: 'Ende',
                            isExpanded: true,
                            expandableDateFormat: 'EEEE, dd. MMMM yyyy',
                            datePickerType: DatePickerType.date,
                            onDateSelected: _handleNewDate,
                            onEventSelected: _handleNewEvent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: DraggableScrollableSheet(
                    expand: true,
                    initialChildSize: 0.4,
                    minChildSize: 0.4,
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
                                          onTap: _addNewEvent,
                                          child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(25),
                                                color: Colors.pinkAccent,
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.all(15.0),
                                                child: Text("Add Chemo event",
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30.0,top: 30),
                                      child: Text("Chemotherapy Sessions",
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.grey.shade700),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 200,
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: widget.events.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(left: 40.0, right: 40,top: 20),
                                        child: GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              _showConfirmationDialog(context);
                                              attended_chemo.add(ChemoData(widget.events[index].startTime, 1),);
                                            });

                                          },
                                          child: Container(
                                            height: 60,
                                            width: MediaQuery.of(context).size.width - 300,
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
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      widget.events[index].description,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 14,
                                                          color: Colors.grey.shade700),
                                                    ),
                                                    Text(
                                                      widget.events[index].startTime.toString(),
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
                                        ),
                                      ); // <-- Removed the unnecessary space here
                                    },
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 30.0,top: 30),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [

                                      Text("Statistics",
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.grey.shade700),
                                      ),


                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                widget.chemo.length > 0 ?  Center(
                                    child: Container(
                                        child: SfCartesianChart(
                                            primaryXAxis: const CategoryAxis(),
                                            series: <CartesianSeries>[
                                              // Renders line chart
                                              LineSeries<ChemoData, DateTime>(
                                                dataSource: widget.chemo,
                                                xValueMapper: (ChemoData sales, _) => sales.date,
                                                yValueMapper: (ChemoData sales, _) => sales.attended+1,
                                              ),
                                              LineSeries<ChemoData, DateTime>(
                                                color: Colors.green,
                                                dataSource: attended_chemo,
                                                yValueMapper: (ChemoData sales, _) => sales.attended,
                                                xValueMapper: (ChemoData sales, _) => sales.date,
                                              )
                                            ]
                                        )
                                    )
                                ): Container(
                                  height: 30,
                                  width: 300,
                                  decoration: BoxDecoration(
                                      color: Colors.pinkAccent.shade100,
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Center(child: Text("Add a chemotherapy event for statistics",
                                    style: TextStyle(color: Colors.white),)),
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

  void _addNewEvent() {
    DateTime? startDate;
    DateTime? endDate;
    String note = '';
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Add Chemo Event'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(startDate == null
                    ? 'Select Start Date'
                    : 'Start Date: ${startDate?.toLocal().toString()}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  startDate = await DatePicker.showDateTimePicker(
                    context,
                    showTitleActions: true,
                    minTime: DateTime(2020, 1, 1),
                    maxTime: DateTime(2101, 12, 31),
                  );
                  setState(() {});
                },
              ),
              ListTile(
                title: Text(endDate == null
                    ? 'Select End Date'
                    : 'End Date: ${endDate.toString()}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  endDate = await DatePicker.showDateTimePicker(
                    context,
                    showTitleActions: true,
                    minTime: startDate ?? DateTime(2020, 1, 1),
                    maxTime: DateTime(2101, 12, 31),
                  );
                  setState(() {});
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Note'),
                onChanged: (value) {
                  note = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (startDate != null && endDate != null) {
                  setState(() {
                    widget.chemo.add(ChemoData(startDate!, 1),);
                    addEvents(
                      note,
                      startDate!,
                      endDate!,
                    );
                    widget.events.add(
                        NeatCleanCalendarEvent(
                      'Chemo',
                      description: note,
                      startTime: startDate!,
                      endTime: endDate!,
                      color: Colors.green,
                    ));
                  });
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();

                }
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: Text('Attended the chemo session ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }




}

class ChemoData {
  ChemoData(this.date, this.attended);
  final int attended;
  final DateTime date;

}