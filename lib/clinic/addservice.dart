import 'dart:ffi';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../flutter_session.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'clinicchat_screen.dart';
class AddServiceScreenWidget extends StatefulWidget{
  @override
  AddServiceScreenWidgetState createState(){
    return AddServiceScreenWidgetState();
  }
}

class AddServiceScreenWidgetState extends State<AddServiceScreenWidget>{
  @override
  void initState() {
    super.initState();

  }
  final _formKey = GlobalKey<FormState>();
  var firstname;
  var middlename;
  var lastname;
  var address;
  var email;
  var pass;
  var url;
  var birthday;
  var contact;
  var age;
  var gender;
  var updateUrl;
  dynamic did;
  var id;
  var clinicID;
  PickedFile imageFile;
  TextEditingController serviceController = TextEditingController();

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

  Future saveService(BuildContext context, String service) async {
   var doc =  FirebaseFirestore.instance.collection('Services').doc();
   clinicID = await FlutterSession().get('id');
    await FirebaseFirestore.instance
        .collection('Services')
        .doc(doc.id)
        .set({
      'service': service,
      'clinicID':clinicID,
      'serviceID':doc.id


    })
        .then((value) => print("Services Updated"))
        .catchError((error) => print("Failed to update user: $error"));


  }







  @override
  Widget build(BuildContext context){

    return Container(
        width:MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height,

        decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/background.png"), fit: BoxFit.cover),
    ),
    child:SingleChildScrollView(
        child:Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: serviceController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                    filled: true,
                    labelText: "Service"
                ),
                validator: (value){
                  if(value == null || value.isEmpty){
                    return "Service should not be empty.";
                  }
                  return null;
                },
              ),
            ),




            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(onPressed: (){
                    if(_formKey.currentState.validate()){
                      saveService(context,serviceController.text);

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Successfully Registered")));

                    }

                  }
                      , child: Text("Save")),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: ElevatedButton(onPressed: (){
                //     Navigator.pop(context);
                //   }
                //       , child: Text("Back")),
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(onPressed: (){
                    serviceController.text = "";

                  }
                      , child: Text("Clear")),
                ),

              ],
            ),

          ],
        )
    ),
    ));
  }
}