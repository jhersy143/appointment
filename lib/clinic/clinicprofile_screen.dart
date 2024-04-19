import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'clinicprofile.dart';
import 'clinichome_screen.dart';

class ClinicProfileScreen extends StatelessWidget{
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
        title: Text("Clinic Profile"),
        backgroundColor: Color(0xff00ABE1),
      ),
      body: ClinicProfileFormWidget(),
    );
  }
}