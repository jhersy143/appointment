import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'doctorchat.dart';
import 'doctorhome_screen.dart';
class DoctorChatScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading:    GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context)=>DoctorHomeScreen()));

          },
          child: Icon(
            Icons.menu_book,  // add custom icons also
          ),
        ),
        title: Text("Doctor Chat"),
      ),
      body: DoctorChatWidget(),
    );
  }
}