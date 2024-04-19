import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:appointment/doctor/doctorhome.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../homepage_screen.dart';
import 'clinichome_screen.dart';
import 'consult.dart';
class ConsultPageScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return MaterialApp(
      title: 'ME- Clinic',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
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
          title: Text("Consulation Form"),
          backgroundColor: Color(0xff00ABE1),
        ),
        body: ConsultFormWidget(),
      ),
    );

  }
}