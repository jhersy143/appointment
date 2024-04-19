import 'package:appointment/patient/addappointment_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../flutter_session.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'addconsult_screen.dart';
import 'viewconsult_screen.dart';
class ConsultFormWidget extends StatefulWidget{
  @override
  ConsultFormWidgetState createState(){
    return ConsultFormWidgetState();
  }
}

class ConsultFormWidgetState extends State<ConsultFormWidget>{

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
  Future<dynamic> _appointmentsclinic() async{
    did =  await FlutterSession().get('id');

    print(did);
    List<dynamic> query;
    await FirebaseFirestore.instance
        .collection('ConsultClinic')
        .where('userID',isEqualTo:did)
        .where('status',isEqualTo: 'open')
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
    print(query);
    return query;
  }


  Widget build(BuildContext context){

    return DecoratedBox(
        decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/background.png"), fit: BoxFit.cover),
    ),
    child:
      Center(
          child:  FutureBuilder<dynamic>(
              future: _appointmentsclinic(),
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
                                          leading:  Icon(Icons.assignment_rounded, size: 40,color: Color(0xff00ABE1),),
                                          title:

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(snapshot.data[index]['username'],
                                          style: TextStyle(color: Color(0xff212221),fontSize: 16,fontWeight: FontWeight.bold),
                                              ),

                                            ],
                                          ),
                                          subtitle:  Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text('Details:',
                                            style: TextStyle(color: Color(0xff212221),fontSize: 16,fontWeight: FontWeight.bold),),
                                              Text(snapshot.data[index]['details'],
                                              style: TextStyle(color: Color(0xff212221),fontSize: 16,fontWeight: FontWeight.bold),
                                             ),


                                            ],
                                          ),

                                          onTap: () {
                                            setState(() {
                                              session.set('consultID', snapshot.data[index]['consultID']);

                                            });
                                           Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => viewconsultScreen(),
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


      ));

  }
}