import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'appointmentall.dart';
import '../homepage_screen.dart';
import 'patienthome_screen.dart';
class MyAppointmentAllScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading:    GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context)=>PatientHomeScreen()));

          },
          child: Icon(
            Icons.menu,  // add custom icons also
          ),
        ),
        title: Text("Patient Appointment"),
        backgroundColor: Color(0xff00ABE1),
      ),
      body: MyAppointmentAllFormWidget(),
    );
  }
}