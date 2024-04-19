import 'package:appointment/patient/addappointment_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../flutter_session.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MyAppointmentFormWidget extends StatefulWidget{
  @override
  MyAppointmentFormWidgetState createState(){
    return MyAppointmentFormWidgetState();
  }
}

class MyAppointmentFormWidgetState extends State<MyAppointmentFormWidget>{

  dynamic did;
  var goal;
  var type;
  var doctorID;
  var clinicID;
  QuerySnapshot querySnapshotdata;
  List<dynamic> listItem;
  var session = FlutterSession();
  TextEditingController textController = TextEditingController();
  @override
  Future<dynamic> _appointmentsdoctor() async{
    doctorID =  await FlutterSession().get('id');

    List<dynamic> query;
    await FirebaseFirestore.instance
        .collection('AppointmentDoctor')
        .where('doctorID',isEqualTo:doctorID)
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


  Widget build(BuildContext context){

    return
      Center(
          child:  FutureBuilder<dynamic>(
              future: _appointmentsdoctor(),
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
                                              Text(snapshot.data[index]['username']),

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



                        list ],)
                );
              }
          )


      );

  }
}