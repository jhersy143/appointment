import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:appointment/patient/login.dart';
import 'package:appointment/doctor/doctorsignup.dart';
import '../homepage_screen.dart';
class DoctorSignupScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading:    GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context)=>HomepageScreen()));

          },
          child: Icon(
            Icons.menu_book,  // add custom icons also
          ),
        ),
        title: Text("Doctor Signup Form"),
      ),
      body: DoctorSignupWidget(),
    );
  }
}