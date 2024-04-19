import 'package:flutter/material.dart';
import 'package:appointment/patient/login_screen.dart';
import 'package:appointment/patient/signup.dart';
import 'package:appointment/patient/signup_screen.dart';
import 'package:appointment/simple.dart';
import 'package:appointment/patient/addappointment_screen.dart';
import 'package:appointment/patient/appointments.dart';
import 'package:appointment/patient/cliniclist_screen.dart';
import 'package:appointment/patient/appointments_screen.dart';
import 'patient/login.dart';


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Appointment System',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Appointment System'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _selectedIndex = 0;
  List<Widget> _pages = <Widget>[
    cliniclistScreen(),
    MyLoginFormWidget(),
    MyAppointmentScreen(),
  ];

  _onItemTapped (int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        leading:    GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context)=>LoginScreen()));

          },
          child: Icon(
            Icons.logout,  // add custom icons also
          ),
        ),
        title: Text(widget.title),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [

          BottomNavigationBarItem(icon: Icon(Icons.local_hospital),
              label: "Clinic"),
          BottomNavigationBarItem(icon: Icon(Icons.person),
              label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_rounded),
              label: "Appointment"),

        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      )
    );
  }
}

// Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Row(
// children: [
// Padding(
// padding: const EdgeInsets.all(8.0),
// child: ElevatedButton(onPressed: (){
// Navigator.push(
// context,
// MaterialPageRoute(builder: (context) => LoginScreen())
// );
// }, child: Text("Open Login Form")),
// ),
// Padding(
// padding: const EdgeInsets.all(8.0),
// child: ElevatedButton(onPressed: (){
// Navigator.push(
// context,
// MaterialPageRoute(builder: (context) => SignupScreen())
// );
// }, child: Text("Open Signup Form")),
// ),
// ],
// ),
// Padding(
// padding: const EdgeInsets.all(8.0),
// child: ElevatedButton(onPressed: (){
// Navigator.push(
// context,
// MaterialPageRoute(builder: (context) => AccountListScreen())
// );
// }, child: Text("Open Account List")),
// ),
// ],
// )