import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:appointment/patient/login.dart';
import 'package:appointment/patient/addappointment.dart';

class addapointmentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Appointment Form"),
      ),
      body: addappointmentFormWidget(),
    );
  }
}