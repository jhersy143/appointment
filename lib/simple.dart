import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MySimpleFormWidget extends StatefulWidget{
  @override
  MySimpleFormWidgetState createState(){
    return MySimpleFormWidgetState();
  }
}

class MySimpleFormWidgetState extends State<MySimpleFormWidget>{
  final _formKey = GlobalKey<FormState>();
  TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context){
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: textController,
            decoration: InputDecoration(
              labelText: "Enter your name"
            ),
            validator: (value){
              if(value == null || value.isEmpty){
                return "This field should not be empty.";
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(onPressed: (){
              if(_formKey.currentState.validate()){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Your input is: ${textController.text}")));
              }
            }
            , child: Text("Submit")),
          )
        ],
      )
    );
  }
}