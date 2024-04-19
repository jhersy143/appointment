import 'package:appointment/patient/login_screen.dart';
import 'package:appointment/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:appointment/database_helper.dart';
import '../flutter_session.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appointment/clinic/clinicsignup_screen.dart';
import 'clinichome_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class ClinicLoginFormWidget extends StatefulWidget{
  @override
  ClinicLoginFormWidgetState createState(){
    return ClinicLoginFormWidgetState();
  }
}

class ClinicLoginFormWidgetState extends State<ClinicLoginFormWidget>{
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var session = FlutterSession();
  var contact;
  var password;
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
  Future<dynamic> _forgotpassword(String email) async{

    await FirebaseFirestore.instance
        .collection('Clinics')
        .where('email',isEqualTo: email)
        .get()
        .then((QuerySnapshot querySnapshot) {

      if(querySnapshot.docs.isEmpty)
      {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Invalid Email!'),
        ));

      }
      else
      {
        querySnapshot.docs.forEach((doc) {

          setState(() {
            contact = doc["contact"];
            password = doc["password"];
          });

          print(doc.id);
        });
        sendMessage(password,contact);

      }

    });
  }
  Future<dynamic> sendMessage(String password,String contact) async{
    var message = "Your password is"+ " " +password;
    final response =  await http.post(
      Uri.parse('https://semaphore.co/api/v4/messages'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'apikey' :'9c0b42f5ec4f38560ae75e5f3708122d', //Your API KEY
        'number' :contact,
        'message':message,
        'sendername': 'SEMAPHORE'
      }),
    );


    return jsonDecode(response.body);
  }
  Future<dynamic> _login(String email,String pass) async{

    await FirebaseFirestore.instance
        .collection('Clinics')
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
          var name = doc["clinicname"];
          setState(() {
            session.set("id", doc.id);
            session.set("profileurl", doc["url"]);
            session.set("name", name);
          });


        });

        Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=>ClinicHomeScreen()));
      }

    });
  }

  @override
  Widget build(BuildContext context){
    return Container(
        width:MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/background.png"), fit: BoxFit.cover),
    ),
    child:Form(
        key: _formKey,
        child:
        SingleChildScrollView(
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width:double.infinity, height: 120,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color(0xff00ABE1),
                  ),
                  child:
                  Container(
                      margin: EdgeInsets.only(top:20),
                      child:Center(child:Text("WELCOME"
                          ,style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold,color: Colors.white)
                      ),)
                  )

              ),
              Container(
                width: MediaQuery.of(context).size.width*0.9,
                margin: EdgeInsets.only(top:50),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    validator: validateEmail,
                  ),
                ),),
              Container(
                width: MediaQuery.of(context).size.width*0.9,
                margin: EdgeInsets.only(top:10),
                child:
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "Password should not be empty.";
                      }
                      return null;
                    },
                  ),
                ),),
              Container(
                  width: MediaQuery.of(context).size.width*0.87, height: 60,
                  margin: EdgeInsets.only(top:10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xff00ABE1),
                  ),
                  child:
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff00ABE1)),
                          elevation: MaterialStateProperty.all(0),
                        ),
                        onPressed: (){
                          if(_formKey.currentState.validate()){
                            _login(emailController.text, passwordController.text);
                          }
                        }
                        , child: Text("LOGIN",
                      style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                    )

                    ),
                  )),
              Container(
                  width: MediaQuery.of(context).size.width*0.87, height: 60,
                  margin: EdgeInsets.only(top:10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xff00ABE1),
                  ),
                  child:
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff259B9A)),
                          elevation: MaterialStateProperty.all(0),
                        ),
                        onPressed: (){
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context)=>ClinicSignupScreen()),
                          );
                        }
                        , child: Text("CREATE NEW ACCOUNT")),
                  )
              ),
              Container(
                width: MediaQuery.of(context).size.width*0.87, height: 60,
                margin: EdgeInsets.only(top:10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xff00ABE1),
                ),
                child:
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child:  ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff259B9A)),
                        elevation: MaterialStateProperty.all(0),
                      ),
                      onPressed: (){
                        _forgotpassword(emailController.text);
                      }
                      , child: Text("FORGOT PASSWORD",
                    style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                  )

                  ),
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
        ),

    ));
  }
}