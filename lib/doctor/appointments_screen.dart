import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'appointments.dart';
import '../homepage_screen.dart';
import 'doctorhome_screen.dart';
class MyAppointmentScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading:    GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context)=>DoctorHomeScreen()));

          },
          child: Icon(
            Icons.menu_book,  // add custom icons also
          ),
        ),
        title: Text("Patient Appointment"),
      ),
      body: MyAppointmentFormWidget(),
    );
  }
}