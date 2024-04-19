import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'viewpatient.dart';
import 'doctorhome_screen.dart';
class ViewPatientScreen extends StatelessWidget{
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
        title: Text("Patient List"),
      ),
      body: PatientProfileFormWidget(),
    );
  }
}