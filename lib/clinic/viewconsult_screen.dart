import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:appointment/patient/login.dart';
import 'viewconsult.dart';

class viewconsultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Consult Form"),
        backgroundColor: Color(0xff00ABE1),
      ),
      body: viewconsultFormWidget(),
    );
  }
}