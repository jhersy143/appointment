
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
class addconsultFormWidget extends StatefulWidget{
  @override
  addconsultFormWidgetState createState(){
    return addconsultFormWidgetState();
  }
}

class addconsultFormWidgetState extends State<addconsultFormWidget>{
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
  var consultID;
  var clinicname;
  var typeappointment;
  var name;
  var appointmentDatetime;
  var appointmentwith;
  var username;
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

  Future<dynamic> _doctorappointment() async{
    id =  await FlutterSession().get('id');
    appointmentID = await FlutterSession().get('appointmentID');
    doctorname =  await FlutterSession().get('doctorname');
    List<dynamic> query;
    await FirebaseFirestore.instance
        .collection('AppointmentDoctor')
        .where('appointmentID',isEqualTo: appointmentID)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if(querySnapshot.docs.isEmpty)
      {


      }
      else
      {
        if(appointmentID!=null){
          query =  querySnapshot.docs.map((doc) =>doc.data()).toList();
          print(appointmentID);
        }

      }

    });
    return query;
  }

  Future<dynamic> _clinicappointment() async{
    id =  await FlutterSession().get('id');
    consultID = await FlutterSession().get('consultID');
    clinicname =  await FlutterSession().get('clinicname');
    List<dynamic> query;
    await FirebaseFirestore.instance
        .collection('ConsultClinic')
        .where('consultID',isEqualTo: consultID)

        .get()
        .then((QuerySnapshot querySnapshot) {
      if(querySnapshot.docs.isEmpty)
      {


      }
      else
      {
        if(appointmentID!=null){
          query =  querySnapshot.docs.map((doc) =>doc.data()).toList();
          print(appointmentID);
        }

      }

    });
    return query;
  }
  Future<dynamic> _type() async{
    typeappointment =  await FlutterSession().get('type');
    typeappointment == "doctorappointment" ?  appointmentwith =  await FlutterSession().get('doctorname')
        :appointmentwith =  await FlutterSession().get('username');
    print(typeappointment);
    appointmentwith =  await FlutterSession().get('username');
  }
  //add doctor appointment---------------
  void _adddoctorapointment(String date,String time,String doctorName,String appointmentDate) async{
    id =  await FlutterSession().get('id');
    name = await FlutterSession().get('name');
    doctorID = await FlutterSession().get('doctorID');
    doctorname =  await FlutterSession().get('doctorname');
    var doc = FirebaseFirestore.instance.collection('AppointmentDoctor').doc();
    await FirebaseFirestore.instance
        .collection('AppointmentDoctor')
        .doc(doc.id)
        .set({'appointmentID':doc.id,'date': date,'time':time,
      'doctorName':doctorname,'userID':id,'doctorID':doctorID,'username':name,'appointmentDate':appointmentDate})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Successfully Saved!'),
    ));

  }
  //add clinic appointment---------------
  void _addclinicconsult(String date,String time,String clinicName,String appointmentDate,String details) async{
    id =  await FlutterSession().get('patientID');
    name = await FlutterSession().get('name');
    clinicID = await FlutterSession().get('id');
    username =  await FlutterSession().get('username');
    var doc = FirebaseFirestore.instance.collection('ConsulClinic').doc();
    await FirebaseFirestore.instance
        .collection('ConsultClinic')
        .doc(doc.id)
        .set({'consultID':doc.id,'date': date,'time':time,
      'clinicName':clinicname,'userID':id,
      'clinicID':clinicID,'username':username,'appointmentDate':appointmentDate,
      'details':details,'status':'open','recommendation':''})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Successfully Saved!'),
    ));

  }
  //add clinic appointment---------------
  // _updatedoctorapointment---------------
  void _updatedoctorapointment(String date,String time,String doctorName,String appointmentDate) async{
    id =  await FlutterSession().get('id');
    doctorID = await FlutterSession().get('doctorID');
    name = await FlutterSession().get('name');
    doctorname =  await FlutterSession().get('doctorname');
    var doc = FirebaseFirestore.instance.collection('AppointmentDoctor').doc();
    await FirebaseFirestore.instance
        .collection('AppointmentDoctor')
        .doc(doc.id)
        .update({'appointmentID':doc.id,'date': date,'time':time,
      'doctorName':doctorname,'userID':id,'doctorID':doctorID,'username':name,'appointmentDate':appointmentDate})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Successfully Saved!'),
    ));

  }
// _updatedoctorapointment---------------
  // _updateclinicapointment---------------
  void _updateclinicapointment(String date,String time,String clinicName,String appointmentDate) async{
    id =  await FlutterSession().get('patientID');
    clinicID = await FlutterSession().get('id');
    name = await FlutterSession().get('name');
    doctorname =  await FlutterSession().get('doctorname');
    var doc = FirebaseFirestore.instance.collection('AppointmentClinic').doc();
    await FirebaseFirestore.instance
        .collection('AppointmentClinic')
        .doc(doc.id)
        .update({'appointmentID':doc.id,'date': date,'time':time,
      'clinicName':clinicname,'userID':id,'clinicID':clinicID,'username':name,'appointmentDate':appointmentDate})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Successfully Saved!'),
    ));

  }
  @override
  void initState() {
    // TODO: implement initState
    appointmentDatetime = DateTime.now().toString();
    appointmentDate = appointmentDatetime.substring(0,10);
    appointmentTime = appointmentDatetime.substring(12,16);
    _type();
    super.initState();
  }
  @override
  Widget build(BuildContext context){

    return DecoratedBox(
        decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/background.png"), fit: BoxFit.cover),
    ),
    child:Form(
        key: _formKey,
        child:FutureBuilder<dynamic>(
            future: typeappointment == "doctorappointment" ?_doctorappointment():_clinicappointment(),
            builder:(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              List<Widget> children;
              print(snapshot.hasData);
              if(snapshot.hasData){

                children = [ Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(typeappointment == "doctorappointment" ?snapshot.data[0]['doctorName']:snapshot.data[0]['username']),
                ),
                  DateTimePicker(
                    type: DateTimePickerType.dateTimeSeparate,
                    dateMask: 'd MMM, yyyy',
                    initialValue: snapshot.data[0]['appointmentDate'],
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    icon: Icon(Icons.event),
                    dateLabelText: 'Date',
                    timeLabelText: "Hour",

                    onChanged: (val){
                      setState(() {
                        appointmentDatetime = val;
                        appointmentDate = val.substring(0,10);
                        appointmentTime = val.substring(12,16);

                      });
                    },
                    validator: (val) {
                      print(val);
                      return null;
                    },
                    onSaved: (val){
                      setState(() {
                        appointmentDatetime = val;
                        appointmentDate = val.substring(0,10);
                        appointmentTime = val.substring(12,16);
                        print(appointmentDate);
                        print(appointmentTime);
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(onPressed: (){
                          if(_formKey.currentState.validate()){
                            typeappointment == "doctorappointment" ?
                            _updatedoctorapointment(appointmentDate,appointmentTime,snapshot.data[0]['doctorName'],appointmentDatetime)
                                :_updateclinicapointment(appointmentDate,appointmentTime,snapshot.data[0]['doctorName'],appointmentDatetime);
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
              else{
                children =  [ Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(appointmentwith==""?"":appointmentwith.toString(),
                    style: TextStyle(fontSize: 20,),

                  ),
                ),
                  Container(
                    width: 300,
                    child: TextFormField(
                      maxLines: 2,
                      enabled: true,

                      controller: detailsController,
                      decoration: InputDecoration(
                          labelText: "Details"
                      ),

                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(onPressed: (){
                          if(_formKey.currentState.validate()){
                            typeappointment == "doctorappointment" ?
                            _adddoctorapointment(appointmentDate,appointmentTime,doctorname,appointmentDatetime)
                                : _addclinicconsult(appointmentDate,appointmentTime,clinicname,appointmentDatetime,detailsController.text);
                            Navigator.pop(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyAppointmentScreen(),
                              ),
                            );
                          }
                        }
                            , child: Text(typeappointment == "doctorappointment" ?"Save Consultation":"Save Consultation")),
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
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,


              );
            }
        )

    ));
  }
}