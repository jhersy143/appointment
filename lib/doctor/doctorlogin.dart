import 'package:appointment/patient/login_screen.dart';
import 'package:appointment/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:appointment/database_helper.dart';
import '../flutter_session.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appointment/doctor/doctorsignup_screen.dart';
import 'doctorhome_screen.dart';
class DoctorLoginFormWidget extends StatefulWidget{
  @override
  DoctorLoginFormWidgetState createState(){
    return DoctorLoginFormWidgetState();
  }
}

class DoctorLoginFormWidgetState extends State<DoctorLoginFormWidget>{
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var session = FlutterSession();
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

  Future<dynamic> _login(String email,String pass) async{

    await FirebaseFirestore.instance
        .collection('Doctors')
        .where('email',isEqualTo: email)
        .where('password',isEqualTo: pass)
        .get()
        .then((QuerySnapshot querySnapshot) {

      if(querySnapshot.docs.isEmpty)
      {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Wrong Username Or Password!'),
        ));

      }
      else
      {
        querySnapshot.docs.forEach((doc) {
          var name = doc["firstname"]+" "+doc["middlename"]+" "+doc["lastname"];
          session.set("id", doc.id);
          session.set("profileurl", doc["url"]);
          session.set("name", name);
          print(doc.id);

        });

        Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=>DoctorHomeScreen()));
      }

    });
  }

  @override
  Widget build(BuildContext context){
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Welcome"
                  ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                )
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                    labelText: "Email"
                ),
                validator: validateEmail,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                    labelText: "Password"
                ),
                validator: (value){
                  if(value == null || value.isEmpty){
                    return "Password should not be empty.";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(onPressed: (){
                if(_formKey.currentState.validate()){
                  _login(emailController.text, passwordController.text);
                }
              }
                  , child: Text("Login")),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(onPressed: (){
                Navigator.push(context,
                  MaterialPageRoute(builder: (context)=>DoctorSignupScreen()),
                );
              }
                  , child: Text("Create New Account")),
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
    );
  }
}