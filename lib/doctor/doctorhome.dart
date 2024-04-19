import 'package:appointment/patient/login_screen.dart';
import 'package:appointment/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:appointment/database_helper.dart';
import '../flutter_session.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appointment/patient/signup_screen.dart';
import 'package:appointment/clinic/clinicsignup_screen.dart';
import 'package:appointment/doctor/doctorsignup_screen.dart';
import 'doctorprofile_screen.dart';
import 'patientlist_screen.dart';
import 'appointments_screen.dart';
class DoctorHomepageWidget extends StatefulWidget{
  @override
  DoctorHomepageWidgetState createState(){
    return DoctorHomepageWidgetState();
  }
}

class DoctorHomepageWidgetState extends State<DoctorHomepageWidget>{
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var session = FlutterSession();
  String validateEmail(String value) {
    Pattern pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value) || value == null)
      return 'Enter a valid email address';
    else
      return null;
  }


  @override
  Widget build(BuildContext context){
    return Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Center(
              child:  Container(
                width: 200, height: 60,
                margin: EdgeInsets.only(bottom:5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child:
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Welcome"
                      ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                    )
                ),
              ),
            ),
            Container(
              width: 200, height: 60,
              margin: EdgeInsets.only(bottom:5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child:
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(onPressed: (){
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>PatientListScreen()),
                  );
                }
                    , child: Text("PATIENT")),
              ),
            ),
            Container(
              width: 200, height: 60,
              margin: EdgeInsets.only(bottom:5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child:
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(onPressed: (){
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>MyAppointmentScreen()),
                  );
                }
                    , child: Text("APPOINTMENT")),
              ),
            ),
            Container(
              width: 200, height: 60,
              margin: EdgeInsets.only(bottom:5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child:
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(onPressed: (){
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>DoctorProfileScreen()),
                  );
                }
                    , child: Text("PROFILE")),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: ElevatedButton(onPressed: (){
            //     Navigator.pop(context);
            //   }
            //       , child: Text("Back")),
            // )
          ],

    );
  }
}