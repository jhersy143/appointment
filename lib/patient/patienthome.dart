import 'package:appointment/patient/login_screen.dart';
import 'package:appointment/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:appointment/database_helper.dart';
import '../flutter_session.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appointment/patient/signup_screen.dart';
import 'package:appointment/clinic/clinicsignup_screen.dart';
import 'package:appointment/doctor/doctorsignup_screen.dart';
import 'profile_screen.dart';
import 'appointments_screen.dart';
import 'cliniclist_screen.dart';
import 'doctorlist_screen.dart';
import 'appointmentall_screen.dart';
import 'clinicpage_screen.dart';
import 'appointmentpage_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
dynamic did;
class PatientHomepageWidget extends StatefulWidget{
  @override
  PatientHomepageWidgetState createState(){
    return PatientHomepageWidgetState();
  }
}

class PatientHomepageWidgetState extends State<PatientHomepageWidget>{
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var session = FlutterSession();
  void showNotification(String appointmentDate) async{

    flutterLocalNotificationsPlugin.show(
        0,
        "APPOINTMENT\n",
        appointmentDate,
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name, channel.description,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/launcher_icon')));
  }
  Future<dynamic> _appointmentsclinic() async{
    did =  await FlutterSession().get('id');
    //clinicID =  await FlutterSession().get('clinicID');
    print(did);
    List<dynamic> query;
    await FirebaseFirestore.instance
        .collection('AppointmentClinic')
        .where('userID',isEqualTo: did)
        .where('seen',isEqualTo: 'false')
        .get()
        .then((QuerySnapshot querySnapshot) {
      if(querySnapshot.docs.isEmpty)
      {


      }
      else
      {
        querySnapshot.docs.forEach((doc) {
          showNotification(doc['date']);
              FirebaseFirestore.instance
              .collection('AppointmentClinic')
              .doc(doc['appointmentID'])
              .update({'seen':'true'});


        }) ;
        query =  querySnapshot.docs.map((doc) =>doc.data()).toList();

      }

    });
    return query;
  }
  @override
  void initState() {
    _appointmentsclinic();
    super.initState();
  }
  @override
  Widget build(BuildContext context){
    return DecoratedBox(
        decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/background.png"), fit: BoxFit.cover),
    ),
    child:Center(child:Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [

        Container(
          width: 250, height: 80,
          margin: EdgeInsets.only(bottom:5,top:100),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child:
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff00ABE1)
                ),
                  elevation: MaterialStateProperty.all(0),
                ),
                onPressed: (){
              Navigator.push(context,
                MaterialPageRoute(builder: (context)=>ClinicPageScreen()),
              );
            }
                , child: Text("CLINIC")),
          ),
        ),

        Container(
          width: 250, height: 80,
          margin: EdgeInsets.only(bottom:5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child:
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff00ABE1)),
                  elevation: MaterialStateProperty.all(0),
                ),
                onPressed: (){
              FlutterSession().set('type', 'clinicappointment');
              Navigator.push(context,
                MaterialPageRoute(builder: (context)=>AppointmentPageScreen()),
              );
            }
                , child: Text("APPOINTMENT")),
          ),
        ),

        Container(
          width: 250, height: 80,
          margin: EdgeInsets.only(bottom:5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child:
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff00ABE1)),
                  elevation: MaterialStateProperty.all(0),
                ),
                onPressed: (){
              Navigator.push(context,
                MaterialPageRoute(builder: (context)=>ProfileScreen()),
              );
            }
                , child: Text("PROFILE")),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: ElevatedButton(onPressed: (){
        //     Navigator.pop(context);
        //   }
        //       , child: Text("Back")),
        // )
      ],

    )
    )
    );
  }
}