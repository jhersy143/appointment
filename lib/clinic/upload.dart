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
import 'package:firebase_storage/firebase_storage.dart';
import 'viewconsult_screen.dart';
import 'dart:async';
import 'dart:convert';
class uploadFormWidget extends StatefulWidget{
  @override
  uploadFormWidgetState createState(){
    return uploadFormWidgetState();
  }
}

class uploadFormWidgetState extends State<uploadFormWidget>{
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
  PickedFile imageFile;
  var url;



  Future _showChoiceDialog(BuildContext context)
  {

    return showDialog(context: context,builder: (BuildContext context){

      return AlertDialog(
        title: Text("Choose option",style: TextStyle(color: Colors.blue),),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Divider(height: 1,color: Colors.blue,),
              ListTile(
                onTap: (){
                  _openGallery(context);
                },
                title: Text("Gallery"),
                leading: Icon(Icons.account_box,color: Colors.blue,),
              ),

              Divider(height: 1,color: Colors.blue,),
              ListTile(
                onTap: (){
                  _openCamera(context);
                },
                title: Text("Camera"),
                leading: Icon(Icons.camera,color: Colors.blue,),
              ),
              Divider(height: 1,color: Colors.blue,),
              ListTile(
                onTap: (){
                  Navigator.pop(context);
                },
                title: Text("Cancel"),
                leading: Icon(Icons.cancel,color: Colors.blue,),
              ),
            ],
          ),
        ),);
    });
  }

  //add clinic consultation---------------
  void _uploadclinicconsult(String date,String time,String details) async{
    consultID =  await FlutterSession().get('consultID');
    String fileName = basename(imageFile.path);
    FirebaseStorage firebaseStorageRef =  FirebaseStorage.instance;
    UploadTask uploadTask =  firebaseStorageRef.ref().child('profilepic/$fileName').putFile(File(imageFile.path));

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    url = await taskSnapshot.ref.getDownloadURL();
    print(url);
    taskSnapshot.ref.getDownloadURL().then(
          (value) => print("Done: $value"),
    );
    var doc = FirebaseFirestore.instance.collection('ResultImages').doc();
    await FirebaseFirestore.instance
        .collection('ResultImages')
        .doc(doc.id)
        .set({'resultID':doc.id,'date': date,'time':time,
        'url':url,'consultID':consultID,'details':details})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));

    ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
      content: Text('Successfully Saved!'),
    ));

  }

// _updatedoctorapointment---------------
  void _openCamera(BuildContext context)  async{
    final  pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    setState(() {
      imageFile = pickedFile;
    });
    Navigator.pop(context);
  }
  void _openGallery(BuildContext context)  async{
    final  pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery ,
    );
    setState(() {
      imageFile = pickedFile;
    });
    Navigator.pop(context);
  }
  void initState() {
    // TODO: implement initState
    appointmentDatetime = DateTime.now().toString();
    appointmentDate = appointmentDatetime.substring(0,10);
    appointmentTime = appointmentDatetime.substring(12,16);
    url = 'https://firebasestorage.googleapis.com/v0/b/cyclista-f4d3b.appspot.com/o/profilepic%2Fdefault.jpg?alt=media&token=ddda3cd3-47af-4878-8584-006f2f6c74dd';

    super.initState();
  }
  @override

  Widget build(BuildContext context){

    return DecoratedBox(
        decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/background.png"), fit: BoxFit.cover),
    ),
    child:Center(child:SingleChildScrollView(
        child:Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Center(
        child: Container(
        width: MediaQuery.of(context).size.width*0.9,
          margin: EdgeInsets.only(top:20,bottom:10),
          child:  TextFormField(
        maxLines: 6,
        enabled: true,

        controller: detailsController,
        decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Details"
    ),

    ),
    ),
        ),
    Center(
      child:
      Container(
          width: 400,
          height: 300,
          margin: EdgeInsets.only(bottom: 10, top: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child:
          imageFile==null? Image.network(url.toString(), width: 350,
              height: 300,
              fit: BoxFit.fitWidth): Image.file(File(imageFile.path),width: 350,
              height: 300,
              fit: BoxFit.fitWidth)


      ),
    ),

    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Padding(
    padding: const EdgeInsets.all(8.0),
    child: ElevatedButton(onPressed: (){
    if(_formKey.currentState.validate()){
      _uploadclinicconsult(appointmentDate,appointmentTime,detailsController.text,);
    Navigator.pop(
    context,
    MaterialPageRoute(
    builder: (context) => viewconsultScreen(),
    ),
    );
    }
    }
    , child: Text("Save")),
    ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(onPressed: (){
          _showChoiceDialog(context);
        }
            , child: Text("Upload")),
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
    ],


        )


)
    )
    ));
  }
}