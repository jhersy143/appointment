import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:appointment/patient/login.dart';
import 'package:appointment/clinic/clinicsignup.dart';
import '../homepage_screen.dart';
class ClinicSignupScreen extends StatelessWidget{
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
            Icons.menu,  // add custom icons also
          ),
        ),
        title: Text("Clinic Signup Form"),
          backgroundColor: Color(0xff00ABE1)
      ),
      body: ClinicSignupWidget(),
    );
  }
}