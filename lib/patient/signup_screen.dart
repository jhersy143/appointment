import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:appointment/patient/login.dart';
import 'package:appointment/patient/signup.dart';

class SignupScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("PATIENT SIGNUP FORM"),
          backgroundColor: Color(0xff00ABE1)
      ),
      body: MySignupFormWidget(),
    );
  }
}