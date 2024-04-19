import 'dart:ffi';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../flutter_session.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'doctorchat_screen.dart';
class PatientProfileFormWidget extends StatefulWidget{
  @override
  PatientProfileWidgetState createState(){
    return PatientProfileWidgetState();
  }
}

class PatientProfileWidgetState extends State<PatientProfileFormWidget>{
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) =>  _profile());
  }
  final _formKey = GlobalKey<FormState>();
  var firstname;
  var middlename;
  var lastname;
  var address;
  var email;
  var pass;
  var url;
  var birthday;
  var contact;
  var age;
  var gender;
  var updateUrl;
  dynamic did;
  var id;
  PickedFile imageFile;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController birthController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();
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

  Future<dynamic> _profile() async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "a@gmail.com",
          password: "password"
      );
      // Disable persistence on web platforms

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    did =  await FlutterSession().get('patientID');
    List<dynamic> query=[];
    await FirebaseFirestore.instance
        .collection('Users')
        .where('patientID',isEqualTo: did)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if(querySnapshot.docs.isEmpty)
      {


      }
      else
      {

        querySnapshot.docs.forEach((doc) {
          if(doc['url']==""){
            url = 'https://firebasestorage.googleapis.com/v0/b/cyclista-f4d3b.appspot.com/o/profilepic%2Fdefault.jpg?alt=media&token=ddda3cd3-47af-4878-8584-006f2f6c74dd';
          }
          else{
            url  = doc['url'];
          }

          query = [firstname = doc['firstname'],
            middlename = doc['middlename'],
            lastname = doc['lastname'],
            address = doc['address'],
            email = doc['email'],
            pass = doc['password'],
            url,
            birthday = doc['birthday'],
            contact = doc['contact'],
            age = doc['age'],
            gender = doc['gender']
          ];
          print(doc.id);

        });

      }

    });
    return query;
  }

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

  @override
  Widget build(BuildContext context){

    return SingleChildScrollView(
        child:
        Form(
            key: _formKey, child:

        FutureBuilder<dynamic>(
            future: _profile(),
            builder:(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              List<Widget> children;

              if(snapshot.hasData){
                firstNameController.text = snapshot.data[0];
                middleNameController.text = snapshot.data[1];
                lastNameController.text = snapshot.data[2];
                addressController.text = snapshot.data[3];
                emailController.text = snapshot.data[4];
                passwordController.text = snapshot.data[5];
                confirmPasswordController.text = snapshot.data[5];
                birthController.text = snapshot.data[7];
                ageController.text = snapshot.data[8];
                contactController.text = snapshot.data[9];
                //genderController.text = snapshot.data[10];
                if(snapshot.data[10]=="Male"){
                  id = 1;
                }
                else if(snapshot.data[10]=="Female"){
                  id = 2;
                }
                children = [Container(
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


                )
                  ,

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      enabled: false,
                      controller: firstNameController,
                      decoration: InputDecoration(
                          labelText: "First Name"
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "First name should not be empty.";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      enabled: false,
                      controller: middleNameController,
                      decoration: InputDecoration(
                          labelText: "Middle Name"
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "Middle name should not be empty.";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      enabled: false,
                      controller: lastNameController,
                      decoration: InputDecoration(
                          labelText: "Last Name"
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "Last name should not be empty.";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      enabled: false,
                      controller: emailController,
                      decoration: InputDecoration(
                          labelText: "Email Address"
                      ),
                      validator: validateEmail,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      enabled: false,
                      controller: contactController,
                      decoration: InputDecoration(
                          labelText: "Contact"
                      ),

                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      enabled: false,
                      controller: birthController,
                      decoration: InputDecoration(
                          labelText: "Birthday"
                      ),

                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      enabled: false,
                      controller: ageController,
                      decoration: InputDecoration(
                          labelText: "Age"
                      ),

                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                          children:[
                            Text(
                              'Male',
                              style: new TextStyle(fontSize: 15.0),
                            ),

                            Radio(
                              value: 1,
                              groupValue: id,

                              onChanged: null,
                            ),

                            Text(
                              'Female',
                              style: new TextStyle(fontSize: 15.0),
                            ),

                            Radio(
                              value: 2,
                              groupValue: id,
                              onChanged: null,
                            ),
                          ]
                      )
                  ),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: ElevatedButton(onPressed: (){
                      //     Navigator.pop(context);
                      //   }
                      //       , child: Text("Back")),
                      // ),
                      Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                      builder: (context)=> DoctorChatScreen()

                      ));


                      }
                      , child: Text("Chat")),
                      ),
                      

                    ]
                    ,

                  )
                  ,];

              }
              else if (snapshot.hasError) {
                children = <Widget>[
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  )
                ];


              }
              else {
                children = const <Widget>[
                  SizedBox(
                    child: CircularProgressIndicator(),
                    width: 60,
                    height: 60,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Awaiting result...'),
                  )
                ];
              }

              return   Column(
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: children

              );
            }
        )

        )
    );
  }
}