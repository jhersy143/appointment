import 'package:appointment/patient/login_screen.dart';
import 'package:appointment/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:appointment/database_helper.dart';
import 'flutter_session.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appointment/patient/login_screen.dart';
import 'package:appointment/clinic/cliniclogin_screen.dart';
import 'package:appointment/doctor/doctorlogin_screen.dart';
class HomepageWidget extends StatefulWidget{
  @override
  HomepageWidgetState createState(){
    return HomepageWidgetState();
  }
}

class HomepageWidgetState extends State<HomepageWidget>{
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
    return
      DecoratedBox(
        decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/background.png"), fit: BoxFit.cover),
    ),
    child:SingleChildScrollView(child:
    Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        Container(
            width:double.infinity, height: 180,
            margin: EdgeInsets.only(bottom:5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Color(0xff00ABE1),
            ),
            child:
            Container(
                margin: EdgeInsets.only(top:20),
                child:Center(child:Text("ME-CLINIC"
                    ,style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold,color: Colors.white)
                ),)
            )

        ),

        Padding(padding: EdgeInsets.only(top:100)),
        Container(
          width: 200, height: 150,

          margin: EdgeInsets.only(bottom:5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xff00ABE1),
          ),
          child:
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff00ABE1)),
                    elevation: MaterialStateProperty.all(0)

                ),
                onPressed: (){
                  Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context)=>LoginScreen()),
                  );
                }
                , child: Column(
              mainAxisAlignment:MainAxisAlignment.center,
              children: [

                Icon(Icons.person_search_rounded, size: 60,),
                Padding(padding: const EdgeInsets.all(10.0),),
                Text("PATIENT",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
              ],)

            ),
          ),
        ),
        Padding(padding: EdgeInsets.only(top:20)),
        Container(
          width: 200, height: 150,
          margin: EdgeInsets.only(bottom:5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xff00ABE1),
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
                    MaterialPageRoute(builder: (context)=>ClinicLoginScreen()),
                  );
                }
                , child: Column(
              mainAxisAlignment:MainAxisAlignment.center,
              children: [

                Icon(Icons.local_hospital_rounded, size: 60,),
                Padding(padding: const EdgeInsets.all(10.0),),
                Text("CLINIC",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
              ],)
            ),
          ),
        ),
        Container(
            width:double.infinity, height: 150,
            margin: EdgeInsets.only(top:MediaQuery.of(context).size.width*0.190),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Color(0xff00ABE1),
            ),
            child:
            Container(
                margin: EdgeInsets.only(top:20),
                child:Center(child:Text("WELCOME"
                    ,style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold,color: Colors.white)
                ),)
            )

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
      ,)
      )
     ;
  }
}