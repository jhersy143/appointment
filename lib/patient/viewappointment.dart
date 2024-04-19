import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:appointment/patient/cliniclist_screen.dart';
import 'package:appointment/patient/appointments_screen.dart';
import '../../flutter_session.dart';

import 'dart:io';
class viewappointmentFormWidget extends StatefulWidget{
  @override
  viewappointmentFormWidgetState createState(){
    return viewappointmentFormWidgetState();
  }
}

class viewappointmentFormWidgetState extends State<viewappointmentFormWidget>{
  final _formKey = GlobalKey<FormState>();
  TextEditingController goalController = TextEditingController();
  TextEditingController percentageController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  dynamic clinicID;
  var id;
  var appointmentDate;
  var appointmentTime;
  var doctorID;
  var appointmentID;
  var doctorname;
  var clinicname;
  var typeappointment;
  var name;
  var appointmentDatetime;
  var appointmentwith;
  PickedFile imageFile;
  var url;
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


  Future<dynamic> _clinicappointment() async{
    id =  await FlutterSession().get('id');
    print(appointmentID);
    appointmentID = await FlutterSession().get('appointmentID');
    clinicname =  await FlutterSession().get('clinicname');
    List<dynamic> query;

    await FirebaseFirestore.instance
        .collection('AppointmentClinic')
        .where('appointmentID',isEqualTo: appointmentID)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if(querySnapshot.docs.isEmpty)
      {


      }
      else
      {

        query =  querySnapshot.docs.map((doc) =>doc.data()).toList();


      }

    });
    return query;
  }
  Future<dynamic> _type() async{
    typeappointment =  await FlutterSession().get('type');
    typeappointment == "doctorappointment" ?  appointmentwith =  await FlutterSession().get('doctorname')
        :appointmentwith =  await FlutterSession().get('clinicname');


  }


  // _updateclinicapointment---------------
  void _updateclinicapointment(String date,String time,String clinicName,String appointmentDate) async{
    id =  await FlutterSession().get('id');
    clinicID = await FlutterSession().get('clinicID');
    name = await FlutterSession().get('name');
    doctorname =  await FlutterSession().get('doctorname');
    appointmentID = await FlutterSession().get('appointmentID');
    //var doc = FirebaseFirestore.instance.collection('AppointmentClinic').doc();
    await FirebaseFirestore.instance
        .collection('AppointmentClinic')
        .doc(appointmentID)
        .update({'appointmentID':appointmentID,'date': date,'time':time,
      'clinicName':clinicname,'userID':id,'clinicID':clinicID,'username':name,'appointmentDate':appointmentDate})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Successfully Saved!'),
    ));

  }
  Future<dynamic> _consultresult () async{
    appointmentID =  await FlutterSession().get('appointmentID');

    List<dynamic> query;
    await FirebaseFirestore.instance
        .collection('ResultImages')
        .where('appointmentID',isEqualTo:appointmentID)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if(querySnapshot.docs.isEmpty)
      {


      }
      else
      {

        query =  querySnapshot.docs.map((doc) =>doc.data()).toList();

      }

    });
    return query;
  }
  @override
  void initState() {
    // TODO: implement initState
    appointmentDatetime = DateTime.now().toString();
    appointmentDate = appointmentDatetime.substring(0,10);
    appointmentTime = appointmentDatetime.substring(12,16);
    _type();
    url = 'https://firebasestorage.googleapis.com/v0/b/cyclista-f4d3b.appspot.com/o/profilepic%2Fdefault.jpg?alt=media&token=ddda3cd3-47af-4878-8584-006f2f6c74dd';
    super.initState();
  }
  @override
  Widget build(BuildContext context){

    return DecoratedBox(
        decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/background.png"), fit: BoxFit.cover),
    ),
    child:Center (
        child:SingleChildScrollView(
            child:Column(children:[
              Form(
                  key: _formKey,
                  child:FutureBuilder<dynamic>(
                      future: _clinicappointment(),
                      builder:(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                        List<Widget> children;
                        print(snapshot.hasData);
                        if(snapshot.hasData){

                          detailsController.text = snapshot.data[0]['details'];
                          children = [

                            Padding(
                            padding: const EdgeInsets.only(top:100.0,left:30),
                            child: Text(snapshot.data[0]['username'],
                                style:TextStyle(color: Color(0xff212221),fontSize: 18,fontWeight: FontWeight.bold)
                            ),
                          ),
                            Center(child:
                            Container(
                              width: MediaQuery.of(context).size.width*0.9,
                              margin: EdgeInsets.only(top:50,bottom:10),
                              child: TextFormField(
                                maxLines: 6,
                                enabled: true,

                                controller: detailsController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Details",
                                  fillColor: Colors.white,
                                  filled: true,
                                ),

                              ),
                            ),),
                            Center(
                                child:Container(
                            width: MediaQuery.of(context).size.width*0.9,
                            margin: EdgeInsets.only(bottom:30),
                            child:
                            DateTimePicker(
                              type: DateTimePickerType.dateTimeSeparate,
                              dateMask: 'd MMM, yyyy',
                              initialValue: snapshot.data[0]['appointmentDate'],
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              icon: Icon(Icons.event),
                              dateLabelText: 'Date',
                              timeLabelText: "Hour",
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                fillColor: Colors.white,
                                filled: true,

                              ),
                              onChanged: (val){
                                setState(() {
                                  appointmentDatetime = val;
                                  appointmentDate = val.substring(0,10);
                                  appointmentTime = val.substring(12,16);

                                });
                              },
                              validator: (val) {

                                return null;
                              },
                              onSaved: (val){
                                setState(() {
                                  appointmentDatetime = val;
                                  appointmentDate = val.substring(0,10);
                                  appointmentTime = val.substring(12,16);

                                });
                              },
                            ),) ),

                          ];

                        }
                        else if (snapshot.hasError) {

                          children = [
                            Padding(

                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 80,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                color:  Colors.white,
                                elevation: 3,
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.error_outline,
                                        color: Colors.red,
                                        size: 60,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 16),
                                        child: Text('Error: ${snapshot.error}'),
                                      ),]
                                ),
                              ),
                            ),


                          )];

                        }else {
                          children =  [Padding(

                            padding: const EdgeInsets.all(8.0),

                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              color:  Colors.white,
                              elevation: 3,
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [

                                    SizedBox(
                                      child: CircularProgressIndicator(),
                                      width: 60,
                                      height: 40,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text('Awaiting result...'),
                                    ),]
                              ),
                            ),

                          )];



                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: children,


                        );
                      }
                  )

              )
              ,
              FutureBuilder<dynamic>(
                  future: _consultresult(),
                  builder:(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    var list;
                    if(snapshot.hasData){


                      list =
                          Flexible(

                            child: ListView.builder(
                                itemCount:    snapshot.data.length,
                                itemBuilder: (BuildContext context, int index){
                                  url = snapshot.data[index]['url'];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),

                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      color:  Colors.white,
                                      elevation: 3,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,

                                        children: [

                                          ListTile(

                                            title:

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                            Flexible(child:Image.network(url.toString(), width: 350,
                                                    height: 300,
                                                    fit: BoxFit.fitWidth)),

                                              ],
                                            ),
                                            subtitle:  Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                            Padding(
                                            padding: const EdgeInsets.all(1.0),
                                              child:  Text('Details:',style: TextStyle(color: Color(0xff212221),fontSize: 18,fontWeight: FontWeight.bold)),
                                            ),
                                                Flexible(child:  Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child:   Text(snapshot.data[index]['details'],style: TextStyle(color: Color(0xff212221),fontSize: 18,fontWeight: FontWeight.bold)),
                                                ))




                                              ],
                                            ),

                                          )
                                        ],
                                      ),
                                    ),

                                  );
                                  //${accounts[index].first_name}
                                }),
                          );


                    }

                    else {
                      list =  Padding(

                        padding: const EdgeInsets.all(8.0),

                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          color:  Colors.white,
                          elevation: 3,
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [

                                SizedBox(
                                  child: CircularProgressIndicator(),
                                  width: 60,
                                  height: 40,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text('Awaiting result...'),
                                ),]
                          ),
                        ),

                      );



                    }

                    return   Container(
                      height: 800,
                      child:Column(children:[
                        Padding(
                            padding:EdgeInsets.all(20),
                            child: Text('Results',style: TextStyle(color: Color(0xff212221),fontSize: 24,fontWeight: FontWeight.bold)),),

                        list,
                      ]),


                    );
                  }
              ),
            ]
            )
        )
    )
    );
  }
}