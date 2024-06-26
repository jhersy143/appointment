import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../flutter_session.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
class DoctorChatWidget extends StatefulWidget{
  @override
  DoctorChatWidgetState createState(){
    return DoctorChatWidgetState();
  }
}

class DoctorChatWidgetState extends State<DoctorChatWidget>{

  var patientID;
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

    chat = _chat();
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) => _refresh());
  }

  Future<dynamic> _refresh() async{
    if(mounted){
      setState(() {
        chat = _chat();
      });
    }


  }

  Future<dynamic> _chat() async{
    patientID =  await FlutterSession().get('patientID');
    doctorID = await FlutterSession().get('doctorID');
    List<dynamic> query;
    await FirebaseFirestore.instance
        .collection('Chats')
        .where('patientID',isEqualTo: patientID)
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
        print(query);
      }

    });
    return query;
  }
  Future<dynamic> _addchat(String message)async{
    patientID =  await FlutterSession().get('patientID');
    doctorID = await FlutterSession().get('id');
    var doc =FirebaseFirestore.instance.collection('Chats').doc();
    await FirebaseFirestore.instance
        .collection('Chats')
        .doc(doc.id)
        .set({
      'patientID':patientID,
      'doctorID':doctorID,
      'datetime':DateTime.now(),
      'message':message,
      'type':'doctor',
      'chatID':doc.id
    })
        .then((value) => chatController.text="")
        .catchError((error) => print("Failed to update user: $error"));

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
                                          alignment:  snapshot.data[index]['type'] == "doctor"?
                                          Alignment.centerRight:Alignment.centerLeft,
                                          child:Container(

                                            width: 250,

                                            child:snapshot.data[index]['type'] == "bot"?
                                            Card(
                                              ):
                                            Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8.0),
                                              ),
                                              elevation:0,
                                              color:  snapshot.data[index]['type'] == "doctor"?
                                              Colors.lightBlueAccent:Colors.grey,
                                              child:

                                              ListTile(

                                                title: Text(snapshot.data[index]['message']
                                                  ,style:
                                                  TextStyle(color:
                                                  snapshot.data[index]['type'] == "doctor"?
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