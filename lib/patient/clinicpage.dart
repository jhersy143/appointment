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
import 'profile_screen.dart';
import 'appointments_screen.dart';
import 'cliniclist_screen.dart';
import 'doctorlist_screen.dart';
import 'patienthome_screen.dart';
class ClinicPageWidget extends StatefulWidget{
  @override
  ClinicPageWidgetState createState(){
    return ClinicPageWidgetState();
  }
}

class ClinicPageWidgetState extends State<ClinicPageWidget>{

  var session = FlutterSession();

  @override
  Widget build(BuildContext context){
    return     DecoratedBox(
        decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/background.png"), fit: BoxFit.cover),
    ),
    child:Center(
        child:Column(
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [

        Container(
          width: 250, height: 80,
          margin: EdgeInsets.only(bottom:5,top:100),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child:
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff00ABE1)),
                  elevation: MaterialStateProperty.all(0),
                ),
                onPressed: (){
              Navigator.push(context,
                MaterialPageRoute(builder: (context)=>cliniclistScreen()),
              );
            }
                , child: Text("CLINIC LIST")),
          ),
        ),
        Container(
          width: 250, height: 80,
          margin: EdgeInsets.only(bottom:5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child:
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff00ABE1)),
                  elevation: MaterialStateProperty.all(0),
                ),
                onPressed: (){
              Navigator.push(context,
                MaterialPageRoute(builder: (context)=>doctorlistScreen()),
              );
            }
                , child: Text("DOCTOR LIST")),
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

    )
    )
    );
  }
}