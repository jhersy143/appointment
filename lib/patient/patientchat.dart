import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../flutter_session.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'addappointment_screen.dart';
import 'appointments_screen.dart';
class PatientChatWidget extends StatefulWidget{
  @override
  PatientChatWidgetState createState(){
    return PatientChatWidgetState();
  }
}

class PatientChatWidgetState extends State<PatientChatWidget>{

  dynamic did;
  var goal;
  var type;
  var doctorID;
  TextEditingController chatController = TextEditingController();
  QuerySnapshot querySnapshotdata;
  List<dynamic> listItem;
  var session = FlutterSession();
  var userurl,friendurl,username,friendname;
  Future chat;
  Timer timer;
  int counter = 0;
  TextEditingController textController = TextEditingController();
  void initState() {
    super.initState();
    _deletechat();


    chat = _chat();
    //timer = Timer.periodic(Duration(seconds: 3), (Timer t) => _refresh());
  }

  Future<dynamic> _refresh() async{
    if(mounted){
      setState(() {
        chat = _chat();
      });
    }


  }

  Future<dynamic> _chat() async{
    did =  await FlutterSession().get('id');
    doctorID = await FlutterSession().get('doctorID');
    List<dynamic> query;
    await FirebaseFirestore.instance
        .collection('Chats')
        .where('patientID',isEqualTo: did)
        .where('doctorID',isEqualTo: doctorID)
        .orderBy('datetime',descending: false)
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
  Future<dynamic> _deletechat() async{
    did =  await FlutterSession().get('id');
    doctorID = await FlutterSession().get('doctorID');
    List<dynamic> query;
    await FirebaseFirestore.instance
        .collection('Chats')
        .where('patientID',isEqualTo: did)
        .where('doctorID',isEqualTo: doctorID)
        .where('type',isEqualTo: 'bot')
        .orderBy('datetime',descending: false)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if(querySnapshot.docs.isEmpty)
      {
        _addbotchat();

      }
      else
      {
        querySnapshot.docs.forEach((doc) {
          FirebaseFirestore.instance
              .collection('Chats')
              .doc(doc['chatID'])
              .delete().then((value) => _addbotchat());
        });

      }

    });
    _refresh();
    return query;
  }
  Future<dynamic> _addappointment()async{
    did =  await FlutterSession().get('id');
    doctorID = await FlutterSession().get('doctorID');
    var doc = FirebaseFirestore.instance.collection('Chats').doc();
    var doc2 = FirebaseFirestore.instance.collection('Chats').doc();
    await FirebaseFirestore.instance
        .collection('Chats')
        .doc(doc.id)
        .set({
      'patientID':did,
      'doctorID':doctorID,
      'datetime':DateTime.now(),
      'message':'APPOINTMENT',
      'type':'patient',
      'chatID':doc.id
    })
        .whenComplete(() async{
      await FirebaseFirestore.instance
          .collection('Chats')
          .doc(doc2.id)
          .set({
        'patientID':did,
        'doctorID':doctorID,
        'datetime':DateTime.now(),
        'message':'APPOINTMENT',
        'type':'bot',
        'chatID':doc2.id
      });
    }

          )
        .catchError((error) => print("Failed to update user: $error"));
    _refresh();
  }
  Future<dynamic> _addconsultation()async{
    did =  await FlutterSession().get('id');
    doctorID = await FlutterSession().get('doctorID');
    var doc = FirebaseFirestore.instance.collection('Chats').doc();
    var doc2 = FirebaseFirestore.instance.collection('Chats').doc();
    await FirebaseFirestore.instance
        .collection('Chats')
        .doc(doc.id)
        .set({
      'patientID':did,
      'doctorID':doctorID,
      'datetime':DateTime.now(),
      'message':'CONSULTATION',
      'type':'patient',
      'chatID':doc.id
    })
        .whenComplete(() async{
      await FirebaseFirestore.instance
          .collection('Chats')
          .doc(doc2.id)
          .set({
        'patientID':did,
        'doctorID':doctorID,
        'datetime':DateTime.now(),
        'message':'CONSULTATION',
        'type':'bot',
        'chatID':doc2.id
      });
    }

    )
        .catchError((error) => print("Failed to update user: $error"));
    _refresh();
  }
  Future<dynamic> _addbotchat()async{
    did =  await FlutterSession().get('id');
    doctorID = await FlutterSession().get('doctorID');
    var doc =FirebaseFirestore.instance.collection('Chats').doc();
    await FirebaseFirestore.instance
        .collection('Chats')
        .doc(doc.id)
        .set({
      'patientID':did,
      'doctorID':doctorID,
      'datetime':DateTime.now(),
      'message':'bot',
      'type':'bot',
      'chatID':doc.id
    })
        .then((value) => chatController.text="")
        .catchError((error) => print("Failed to update user: $error"));
    _refresh();
  }

  Future<dynamic> _addchat(String message)async{
    did =  await FlutterSession().get('id');
    doctorID = await FlutterSession().get('doctorID');
    var doc2 =FirebaseFirestore.instance.collection('Chats').doc();
    await FirebaseFirestore.instance
        .collection('Chats')
        .doc(doc2.id)
        .set({
      'patientID':did,
      'doctorID':doctorID,
      'datetime':DateTime.now(),
      'message':message,
      'type':'patient',
      'chatID':doc2.id
    })
        .then((value) => chatController.text="")
        .catchError((error) => print("Failed to update user: $error"));
    _refresh();
  }
  @override
  Widget build(BuildContext context){
    return
      Center(
          child:  FutureBuilder<dynamic>(
              future: chat,
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
                                  child: Column(

                                    children: [
                                      Align(
                                          alignment:  snapshot.data[index]['type'] == "patient"?
                                          Alignment.centerRight:Alignment.centerLeft,
                                          child:Container(

                                            width: 250,

                                            child:snapshot.data[index]['type'] == "bot"?
                                            Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                elevation:0,
                                                color:  snapshot.data[index]['type'] == "patient"?
                                                Colors.lightBlueAccent:Colors.grey,
                                                child:
                                                Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                  child:snapshot.data[index]['message']=="APPOINTMENT"?
                                                  Column(
                                                    children: [
                                                      Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child:Text('Please add appointment!',
                                                              style:TextStyle(color:Colors.white
                                                              ))
                                                      )
                                                      ,
                                                      Padding(
                                                        padding: const EdgeInsets.all(5.0),
                                                        child: ElevatedButton(onPressed: (){
                                                          FlutterSession().set('type', 'doctorappointment');
                                                          Navigator.push(context,
                                                            MaterialPageRoute(builder: (context)=>MyAppointmentScreen()),
                                                          );

                                                        }
                                                            , child: Text("ADD APPOINTMENT")),
                                                      ),

                                                    ],
                                                  )
                                                      :
                                                  snapshot.data[index]['message']=="CONSULTATION"?
                                                    Column(
                                                      children: [
                                                        Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child:Text('Please Explain your symptoms and wait for doctor prescriptions?',
                                                                style:TextStyle(color:Colors.white
                                                                ))
                                                        )
                                                       ,

                                                      ],
                                                    ):
                                                  Column(
                                                    children: [
                                                      Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child:Text('Hi! What can i do for You?',
                                                              style:TextStyle(color:Colors.white
                                                              ))
                                                      )
                                                      ,
                                                      Padding(
                                                        padding: const EdgeInsets.all(5.0),
                                                        child: ElevatedButton(onPressed: (){
                                                          _addappointment();
                                                        }
                                                            , child: Text("APPOINTMENT")),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(5.0),
                                                        child: ElevatedButton(onPressed: (){
                                                          _addconsultation();
                                                        }
                                                            , child: Text("CONSULTATION")),
                                                      )
                                                    ],
                                                  ),

                                                )
                                           ,):
                                            Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8.0),
                                              ),
                                              elevation:0,
                                              color:  snapshot.data[index]['type'] == "patient"?
                                              Colors.lightBlueAccent:Colors.grey,
                                              child:

                                              ListTile(

                                                title: Text(snapshot.data[index]['message']
                                                  ,style:
                                                  TextStyle(color:
                                                  snapshot.data[index]['type'] == "patient"?
                                                  Colors.white:Colors.black,
                                                      fontWeight: FontWeight.bold)

                                                  ,
                                                ),



                                              ),
                                            ),
                                          )
                                      ),

                                    ],

                                  ),
                                ),
                              );

                              //${accounts[index].first_name}
                            }),
                      );


                }

                else {
                  list = Flexible(

                    child: ListView.builder(
                        itemCount:   0,
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
                                elevation:0,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,

                                  children: [
                                    ListTile(

                                      title: Text(""),
                                      subtitle: Text(""),


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

                return   Container(
                    margin: EdgeInsets.only(top:20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        list,

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: 300,
                              child: TextFormField(
                                maxLines: 2,
                                enabled: true,

                                controller: chatController,
                                decoration: InputDecoration(
                                    labelText: "Message"
                                ),

                              ),),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: IconButton(
                                iconSize: 30.0,
                                icon: Icon(Icons.send,color: Colors.blueAccent,
                                ),
                                onPressed: () {

                                  _addchat(chatController.text);

                                },

                              ),
                            ),
                          ],
                        )




                      ],)
                );
              }
          )


      );

  }
}