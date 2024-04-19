import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:appointment/patient/login.dart';
import 'package:appointment/doctor/doctorsignup.dart';
import '../homepage_screen.dart';
import 'adddoctor.dart';
import 'clinichome_screen.dart';
class AddDoctorScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading:    GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context)=>ClinicHomeScreen()));

          },
          child: Icon(
            Icons.menu,  // add custom icons also
          ),
        ),
        title: Text("Add Doctor"),
        backgroundColor: Color(0xff00ABE1),
      ),
      body: AddDoctorWidget(),
    );
  }
}