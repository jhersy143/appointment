import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'historyappointment.dart';
import '../homepage_screen.dart';
import 'patienthome_screen.dart';
import 'historypage_screen.dart';
class HistoryAppointmentAllScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading:    GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context)=>HistoryPageScreen()));

          },
          child: Icon(
            Icons.menu,  // add custom icons also
          ),
        ),
        title: Text("Appointment History")
        ,    backgroundColor: Color(0xff00ABE1),
      ),
      body: HistoryAppointmentAllFormWidget(),
    );
  }
}