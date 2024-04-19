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
import 'package:appointment/clinic/clinicprofile_screen.dart';
import 'package:appointment/doctor/doctorsignup_screen.dart';
import 'patientlist_screen.dart';
import 'services_screen.dart';
import 'appointments_screen.dart';
import 'doctorlist_screen.dart';
import 'appointmentpage_screen.dart';
class ClinicHomepageWidget extends StatefulWidget{
  @override
  ClinicHomepageWidgetState createState(){
    return ClinicHomepageWidgetState();
  }
}

class ClinicHomepageWidgetState extends State<ClinicHomepageWidget>{
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
    return DecoratedBox(
        decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/background.png"), fit: BoxFit.cover),
    ),
    child:Center(child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            Container(
              width: 200, height: 60,
              margin: EdgeInsets.only(bottom:5,top:100),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child:
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff00ABE1)
                    ),
                      elevation: MaterialStateProperty.all(0),
                    ),
                    onPressed: (){
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
                child: ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff00ABE1)
                    ),
                      elevation: MaterialStateProperty.all(0),
                    ),
                    onPressed: (){
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>AppointmentPageScreen()),
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
                child: ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff00ABE1)
                    ),
                      elevation: MaterialStateProperty.all(0),
                    ),
                    onPressed: (){
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>ClinicProfileScreen()),
                  );
                }
                    , child: Text("PROFILE")),
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
                child: ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff00ABE1)
                    ),
                      elevation: MaterialStateProperty.all(0),
                    ),
                    onPressed: (){
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>doctorlistScreen()),
                  );
                }
                    , child: Text("DOCTORS")),
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
                child: ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff00ABE1)
                    ),
                      elevation: MaterialStateProperty.all(0),
                    ),
                    onPressed: (){
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>ServicesScreen()),
                  );
                }
                    , child: Text("SERVICES")),
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

    ),
    )
    );
  }
}