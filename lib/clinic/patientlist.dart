import 'package:appointment/patient/addappointment_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../flutter_session.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'viewpatient_screen.dart';
class PatientListFormWidget extends StatefulWidget{
  @override
  PatientListFormWidgetState createState(){
    return PatientListFormWidgetState();
  }
}

class PatientListFormWidgetState extends State<PatientListFormWidget>{

  dynamic did;
  var goal;
  var type;
  QuerySnapshot querySnapshotdata;
  List<dynamic> listItem;
  var session = FlutterSession();
  var patientlist;
  var search;
  TextEditingController textController = TextEditingController();
  @override
  initState() {
    did =   FlutterSession().get('id');
    // at the beginning, all users are shown
    search = "";
    patientlist = _patient();

    super.initState();
  }

  Future<dynamic> _searchpatient(String search) async{
    List<dynamic> query;
    await FirebaseFirestore.instance
        .collection('Users')
        .where('firstname',isEqualTo: search)
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
  void searchpatient(String value) {
    setState(() {
      if(value==""){
        patientlist = _patient();
      }
      else{
        patientlist = _searchpatient(value);
      }

    });

  }
  Future<dynamic> _patient() async{
    did =  await FlutterSession().get('id');
    List<dynamic> query;
    await FirebaseFirestore.instance
        .collection('Users')
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

  Widget build(BuildContext context){
    return
      DecoratedBox(
        decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/background.png"), fit: BoxFit.cover),
    ),
    child:Center(
          child:  FutureBuilder<dynamic>(
              future: patientlist,
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
                                          leading: Icon(Icons.supervised_user_circle, size: 35,color: Color(0xff00ABE1)),
                                          title:

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(snapshot.data[index]['firstname']+" "+snapshot.data[index]['lastname'],
                                                style: TextStyle(color: Color(0xff212221),fontSize: 18,fontWeight: FontWeight.bold),
                                              ),


                                            ],
                                          ),
                                          subtitle:  Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [

                                              Text(snapshot.data[index]['contact'],
                                                style: TextStyle(color: Color(0xff212221),fontSize: 16,fontWeight: FontWeight.bold),
                                              ),

                                            ],
                                          ),

                                          onTap: () {
                                            var username = snapshot.data[index]["firstname"]+" "+snapshot.data[index]["middlename"]+" "+snapshot.data[index]["lastname"];
                                            setState(() {
                                              session.set('patientID', snapshot.data[index]['patientID']);
                                              session.set('username', username);
                                            });


                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ViewPatientScreen(),
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

                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width*0.9,
                                margin: EdgeInsets.only(top:10,bottom: 20),
                                child:
                                TextField (
                                  onChanged: (value) => searchpatient(value),
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Colors.white,
                                      filled: true,
                                      labelText: 'Search',suffixIcon: Icon(Icons.search),
                                      hintText: 'Search'
                                  ),
                                )
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


      ));

  }
}