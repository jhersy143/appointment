import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
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
import 'upload_screen.dart';
import 'dart:async';
import 'dart:convert';
class viewconsultFormWidget extends StatefulWidget{
  @override
  viewconsultFormWidgetState createState(){
    return viewconsultFormWidgetState();
  }
}

class viewconsultFormWidgetState extends State<viewconsultFormWidget>{
  final _formKey = GlobalKey<FormState>();
  TextEditingController goalController = TextEditingController();
  TextEditingController percentageController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController recomendationController = TextEditingController();
  dynamic clinicID;
  var id;
  var appointmentDate;
  var appointmentTime;
  var doctorID;
  var appointmentID;
  var doctorname;
  var consultID;
  var clinicname;
  var typeappointment;
  var name;
  var appointmentDatetime;
  var appointmentwith;
  var username;
  var url;
  PickedFile imageFile;
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


  Future<dynamic> _consultclinic() async{
    consultID =  await FlutterSession().get('consultID');

    List<dynamic> query;
    await FirebaseFirestore.instance
        .collection('ConsultClinic')
        .where('consultID',isEqualTo:consultID)

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
  Future<dynamic> _consultresult () async{
    consultID =  await FlutterSession().get('consultID');

    List<dynamic> query;
    await FirebaseFirestore.instance
        .collection('ResultImages')
        .where('consultID',isEqualTo:consultID)
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


  //add clinic consultation---------------
  void _updateclinicconsult(String date,String time,String clinicName,String appointmentDate,String details,String recomendation) async{
    id =  await FlutterSession().get('patientID');
    name = await FlutterSession().get('name');
    clinicID = await FlutterSession().get('id');
    username =  await FlutterSession().get('username');
    consultID =  await FlutterSession().get('consultID');
  //  var doc = FirebaseFirestore.instance.collection('ConsultClinic').doc();
    await FirebaseFirestore.instance
        .collection('ConsultClinic')
        .doc(consultID)
        .update({'appointmentID':consultID,'date': date,'time':time,
      'clinicName':clinicname,'userID':id,
      'clinicID':clinicID,'username':username,'appointmentDate':appointmentDate,
      'details':details,'status':'open','recommendation':recomendation})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));

    ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
      content: Text('Successfully Saved!'),
    ));

  }
  void _closedconsult() async{
    id =  await FlutterSession().get('patientID');
    name = await FlutterSession().get('name');
    clinicID = await FlutterSession().get('id');
    username =  await FlutterSession().get('username');
    consultID =  await FlutterSession().get('consultID');
    //  var doc = FirebaseFirestore.instance.collection('ConsultClinic').doc();
    await FirebaseFirestore.instance
        .collection('ConsultClinic')
        .doc(consultID)
        .update({'status':'closed'})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));

    ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
      content: Text('Successfully Saved!'),
    ));

  }

  void initState() {
    // TODO: implement initState
    appointmentDatetime = DateTime.now().toString();
    appointmentDate = appointmentDatetime.substring(0,10);
    appointmentTime = appointmentDatetime.substring(12,16);
    Timer.periodic(Duration(seconds: 3), (Timer t) => _consultresult());
    url = 'https://firebasestorage.googleapis.com/v0/b/cyclista-f4d3b.appspot.com/o/profilepic%2Fdefault.jpg?alt=media&token=ddda3cd3-47af-4878-8584-006f2f6c74dd';
    super.initState();
  }
  @override
  Widget build(BuildContext context){

    return  DecoratedBox(
        decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/background.png"), fit: BoxFit.cover),
    ),
    child:Center(
        child:SingleChildScrollView(
        child:Column(
      children:[
        Form(
        key: _formKey,
        child:FutureBuilder<dynamic>(
            future:_consultclinic(),
            builder:(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              List<Widget> children;
              print(snapshot.data);
              if(snapshot.hasData){
                detailsController.text = snapshot.data[0]['details'];
                recomendationController.text = snapshot.data[0]['recommendation'];
                children = [ Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(snapshot.data[0]['username'],
                        style: TextStyle(fontSize: 20,),),
                ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('status:'+snapshot.data[0]['status'],
                      style: TextStyle(fontSize: 16,),),
                  ),
                  Container(
                    width: 330,

                    child: TextFormField(
                      maxLines: 4,
                      enabled: true,

                      controller: detailsController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          fillColor: Colors.white,
                          filled: true,
                          labelText: "Details"
                      ),

                    ),
                  ),
                  Container(
                    width: 330,

                    child: TextFormField(
                      maxLines: 4,
                      enabled: true,

                      controller: recomendationController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          fillColor: Colors.white,
                          filled: true,
                          labelText: "Recommendation"
                      ),

                    ),
                  ),
                  //---------result

                  //---------end result
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(onPressed: (){
                          if(_formKey.currentState.validate()){
                            _updateclinicconsult(appointmentDate,appointmentTime,snapshot.data[0]['clinicName'],appointmentDatetime,detailsController.text,recomendationController.text);
                            Navigator.pop(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyAppointmentScreen(),
                              ),
                            );
                          }
                        }
                            , child: Text("Update Consult")),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(onPressed: (){
                          if(_formKey.currentState.validate()){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => uploadScreen(),
                              ),
                            );
                          }
                        }
                            , child: Text("Upload")),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(onPressed: (){
                          if(_formKey.currentState.validate()){
                            _closedconsult();
                          }
                        }
                            , child: Text("Closed")),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: ElevatedButton(onPressed: (){
                      //     Navigator.pop(context);
                      //   }
                      //       , child: Text("Back")),
                      // ),


                    ],
                  ),
                ];

              }
              else if (snapshot.hasError) {

                children = [Padding(

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

              }
              else {
                children =  [Padding(

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
                  ),
                )];



              }
              return Column
                (children:[
                  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,


              ),

                ]
              );
            }
        )

    ),
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
                                          mainAxisAlignment: MainAxisAlignment.center,
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
                                              child:  Text('Details:'),
                                            ),
                                            Flexible(child:  Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child:   Text(snapshot.data[index]['details']),
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
                height: 600,
                child:Column(children:[
                list,
                ]),


              );
            }
        ),
      ]
    )
    )
    ));
  }
}