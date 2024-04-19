import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'viewdoctor.dart';
import 'patienthome_screen.dart';
class DoctorProfileScreen extends StatelessWidget{
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
        title: Text("Doctor Profile"),
        backgroundColor: Color(0xff00ABE1),
      ),
      body: DoctorProfileFormWidget(),
    );
  }
}