import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'services.dart';
import 'clinichome_screen.dart';
class ServicesScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading:    GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context)=>ClinicHomeScreen()));

          },
          child: Icon(
            Icons.menu,  // add custom icons also
          ),
        ),
        title: Text("Services List"),
        backgroundColor: Color(0xff00ABE1),
      ),
      body: ServicesFormWidget(),
    );
  }
}