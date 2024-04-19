import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:appointment/patient/login.dart';
import 'viewappointment.dart';

class viewappointmentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Appointment"),
        backgroundColor: Color(0xff00ABE1),
      ),
      body: viewappointmentFormWidget(),
    );
  }
}