import 'package:appointment/patient/addappointment_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../flutter_session.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
class MyAppointmentFormWidget extends StatefulWidget{
  @override
  MyAppointmentFormWidgetState createState(){
    return MyAppointmentFormWidgetState();
  }
}

class MyAppointmentFormWidgetState extends State<MyAppointmentFormWidget>{

  dynamic did;
  var goal;
  var typeappointment;
  QuerySnapshot querySnapshotdata;
  List<dynamic> listItem;
  var session = FlutterSession();
  var clinicID;
  Future _appointment;
  Timer timer;
  TextEditingController textController = TextEditingController();
  @override
  void initState(){
    Timer.periodic(Duration(seconds: 3), (Timer t) => _refresh());
  }
  Future<dynamic> _appointmentsdoctor() async{
    did =  await FlutterSession().get('id');
    List<dynamic> query;
    await FirebaseFirestore.instance
        .collection('AppointmentDoctor')
        .where('userID',isEqualTo:did)
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
  Future<dynamic> _refresh() async{
    if(mounted){
      setState(() {
        _appointment =  typeappointment == "doctorappointment" ? _appointmentsdoctor():_appointmentsclinic();
      });
    }


  }
  Future<dynamic> _appointmentsclinic() async{
    did =  await FlutterSession().get('id');
    clinicID =  await FlutterSession().get('clinicID');

    List<dynamic> query;
    await FirebaseFirestore.instance
        .collection('AppointmentClinic')
        .where('userID',isEqualTo: did)
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
  print(typeappointment);

}
  Widget build(BuildContext context){
    _type();
    return
      Center(
          child:  FutureBuilder<dynamic>(
              future:  _appointment,
              builder:(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                var list;
                if(snapshot.hasData){


                  list =
                      Flexible(

                        child: ListView.builder(
                            itemCount:   snapshot.data.length,
                            itemBuilder: (BuildContext context, int index){

                              return Padding(
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
                                        ListTile(
                                          leading: Icon(Icons.assignment_rounded, size: 40,),
                                          title:

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(typeappointment == "doctorappointment" ?snapshot.data[index]['doctorName'].toString():snapshot.data[index]['clinicName'].toString()),

                                            ],
                                          ),
                                          subtitle:  Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text('Date:'),
                                              Text(snapshot.data[index]['date']),
                                              Text(' '),
                                              Text('Time:'),
                                              Text(snapshot.data[index]['time']),

                                            ],
                                          ),

                                          onTap: () {
                                            session.set('appointmentID', Text(snapshot.data[index]['appointmentID']));
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => addapointmentScreen(),
                                              ),
                                            ).then(
                                                    (value) { setState(() {});});
                                          },
                                        )
                                      ],
                                    ),
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
                  );



                }

                return   Container(
                    margin: EdgeInsets.only(top:20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ElevatedButton(onPressed: (){
                                Navigator.push(context,
                                  MaterialPageRoute(builder: (context)=>addapointmentScreen()),
                                );

                              }
                                  , child: Text("ADD APPOINTMENT")),
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

                        list ],)
                );
              }
          )


      );

  }
}