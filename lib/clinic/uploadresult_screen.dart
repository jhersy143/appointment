import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:appointment/patient/login.dart';
import 'uploadresult.dart';

class uploadresultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Appointment Form"),
        backgroundColor: Color(0xff00ABE1),
      ),
      body: uploadResultFormWidget(),
    );
  }
}