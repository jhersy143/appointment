import 'package:appointment/patient/addappointment_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../flutter_session.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'viewdoctor_screen.dart';
class doctorlistFormWidget extends StatefulWidget{
  @override
  doctorlistFormWidgetState createState(){
    return doctorlistFormWidgetState();
  }
}

class doctorlistFormWidgetState extends State<doctorlistFormWidget>{

  dynamic did;
  var goal;
  var type;
  QuerySnapshot querySnapshotdata;
  List<dynamic> listItem;
  var session = FlutterSession();
  var doctorlist;
  var search;
  TextEditingController textController = TextEditingController();
  @override
  initState() {
    did =   FlutterSession().get('id');
    // at the beginning, all users are shown
    search = "";
    doctorlist = _doctors();

    super.initState();
  }

  Future<dynamic> _searchdoctor(String search) async{
   
    List<dynamic> query;
    await FirebaseFirestore.instance
        .collection('Doctors')
        .where('lastname',isEqualTo: search)
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
  void searchdoctor(String value) {
    setState(() {
      if(value==""){
        doctorlist = _doctors();
      }
      else{
        doctorlist = _searchdoctor(value);
      }

    });

  }
  Future<dynamic> _doctors() async{

    List<dynamic> query;
    await FirebaseFirestore.instance
        .collection('Doctors')
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
              future: doctorlist,
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
                                  height: 100,
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
                                          leading: Icon(Icons.medical_services_rounded, size: 35,color: Color(0xff00ABE1),),
                                          title:

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(snapshot.data[index]['firstname']+" "+snapshot.data[index]['lastname'],style: TextStyle(color: Color(0xff212221),fontSize: 18,fontWeight: FontWeight.bold),),


                                            ],
                                          ),
                                          subtitle:  Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [

                                              Text(snapshot.data[index]['specialization'],style: TextStyle(color: Color(0xff212221),fontSize: 16),),

                                            ],
                                          ),

                                          onTap: () {
                                            var doctorID;

                                            session.set('doctorID', snapshot.data[index]['doctorID']);
                                            session.set('doctorname', snapshot.data[index]['firstname']+" "+snapshot.data[index]['middlename']+" "+snapshot.data[index]['lastname']);

                                            Navigator.push(
                                              context,
                                             MaterialPageRoute(
                                               builder: (context) => DoctorProfileScreen(),
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
                              onChanged: (value) => searchdoctor(value),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
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


      );

  }
}