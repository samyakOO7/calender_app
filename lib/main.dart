
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  CalendarController _controller;

  Map<DateTime,List<dynamic>> _events;
  List<dynamic> _selectedevents;
  TextEditingController _eventcontroller;
  SharedPreferences prefs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller=CalendarController();
    _events={};
    _eventcontroller=TextEditingController();
    _selectedevents=[];
    initPrefs();
  }
  initPrefs() async{
    prefs=await SharedPreferences.getInstance();
    setState(() {
      _events=Map<DateTime,List<dynamic>>.from(decodeMap(json.decode(prefs.getString("events")?? "{}")));
    });

  }
  @override
Map<String,dynamic>encodeMap(Map<DateTime,dynamic>map)
  {
    Map<String,dynamic> newMap = {};
    map.forEach((key, value) {
      return newMap[key.toString()]=map[key];
    });
    return newMap;
  }
  Map <DateTime,dynamic>decodeMap(Map<String,dynamic>map)
  {
    Map<DateTime,dynamic> newMap = {};
    map.forEach((key, value) {
      return newMap[DateTime.parse(key)]=map[key];
    });
    return newMap;
  }

  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Container(alignment: Alignment.centerRight,
          child: Text("Calendar",style: TextStyle(color: Colors.white),)),
actions: <Widget>[
  Container(margin: EdgeInsets.only(left:90,right: 10),
      child: IconButton(onPressed: (){
        _showAddDialog();
      },
          icon: Icon(Icons.add,color: Colors.white,)
      )
  )
  ],
   backgroundColor: Colors.black,
    ),
    body: SingleChildScrollView(

        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Divider(
                color: Colors.white,
              ),

              TableCalendar(
                events: _events,
                weekendDays: [DateTime.sunday],
                daysOfWeekStyle:
                DaysOfWeekStyle(
              weekdayStyle: TextStyle(fontSize: 18,color: Colors.white),
                  weekendStyle:  TextStyle(fontSize: 18,color: Colors.red),

          ),
                calendarStyle: CalendarStyle(

              todayColor: Colors.red,
                selectedColor: Theme.of(context).primaryColor,

                  outsideWeekendStyle: TextStyle(
                    wordSpacing: 40,
                      fontWeight: FontWeight.bold,
                     color: Colors.red.withOpacity(0.6),
                      fontSize: 20
                  ),

                  weekdayStyle: TextStyle(
                      wordSpacing: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                      fontSize: 20
                  ),
                  outsideStyle: TextStyle(
                      wordSpacing: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withOpacity(0.6),
                      fontSize: 20
                  ),
                  weekendStyle: TextStyle(
                      wordSpacing: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 20
                  ),
                  selectedStyle: TextStyle(
                      wordSpacing: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                  highlightSelected: true,
                  renderSelectedFirst: true,
                  todayStyle: TextStyle(
                    wordSpacing: 40,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              holidayStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
              fontSize: 20,
                wordSpacing: 40,

          ),
              ),

              onDaySelected: (day, events, holidays) {
                setState(() {
                _selectedevents=events;
                });
              },


                headerStyle: HeaderStyle(
                  centerHeaderTitle: true,

            titleTextStyle: TextStyle(color:Colors.white,fontSize: 18),
              formatButtonPadding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
              headerMargin: EdgeInsets.only(top:10,bottom: 10),

              leftChevronIcon: Icon(Icons.chevron_left,color: Colors.white,),
              rightChevronIcon:  Icon(Icons.chevron_right,color: Colors.white,),
              formatButtonDecoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20.0),

              ),
                 formatButtonTextStyle: TextStyle(fontWeight:FontWeight.bold,color: Colors.white,fontSize: 14),
                  formatButtonShowsNext: false

                ),

                calendarController: _controller,),
                      Divider(color: Colors.white,),


              ..._selectedevents.map((event) => ListTile(
                      title: Text(event,style: TextStyle(color: Colors.white),),

                      trailing:  IconButton(
                        onPressed: (){
                      setState(() {
                     _selectedevents.clear();
                    _events[_controller.selectedDay]
                        .remove(_eventcontroller.text);
                    _eventcontroller.clear();
                    prefs.setString("events", json.encode(encodeMap(_events)));

                      });



                        },
                        icon: Icon(Icons.delete_outline,color: Colors.white,),
                      ) ,
                    )),



            ],
          ),
        ),
      ),

  );
  }




  _showAddDialog(){
showDialog(context: context,
builder: (context)=>AlertDialog(
   title: Text("Add Reminder"),
  content: TextField(
controller: _eventcontroller,
  ),
  actions: <Widget>[
FlatButton(child: Text("Save"),onPressed: () {

   if (_eventcontroller.text.isEmpty)
    return;


  setState(()  {
    if (_events[_controller.selectedDay] != null) {
      _events[_controller.selectedDay]
          .add(_eventcontroller.text);

    }
    else
      _events[_controller.selectedDay] = [_eventcontroller.text];
    prefs.setString("events", json.encode(encodeMap(_events)));

  Navigator.pop(context);
    _eventcontroller.clear();
  
    },
  );
}               ),

  ],
));
  }
  
}
