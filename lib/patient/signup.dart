import 'dart:ffi';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:path/path.dart';
import 'package:appointment/patient/login_screen.dart';
import 'package:date_time_picker/date_time_picker.dart';
class MySignupFormWidget extends StatefulWidget{
  @override
  MySignupFormWidgetState createState(){
    return MySignupFormWidgetState();
  }
}

class MySignupFormWidgetState extends State<MySignupFormWidget>{
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController birthController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  var birthdate;
  dynamic did;
  PickedFile imageFile;
  var gender;
  var id;
  String url;
  var firstname;
  var middlename;
  var lastname;
  var address;
  var email;
  var pass;

  var updateUrl;
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
  void initState() {
    // TODO: implement initState
    super.initState();
    gender = '';
    id= 0;
    url = 'https://firebasestorage.googleapis.com/v0/b/cyclista-f4d3b.appspot.com/o/profilepic%2Fdefault.jpg?alt=media&token=ddda3cd3-47af-4878-8584-006f2f6c74dd';

  }
  Future saveUsers(BuildContext context,
      String email, String firstname,String middlename,String lastname,
      String gender,String age,String birthday,String contact,String password,String address) async {
    String fileName = basename(imageFile.path);
    FirebaseStorage firebaseStorageRef =  FirebaseStorage.instance;
    UploadTask uploadTask =  firebaseStorageRef.ref().child('profilepic/$fileName').putFile(File(imageFile.path));
    var doc =  FirebaseFirestore.instance.collection('Users').doc();
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    updateUrl = await taskSnapshot.ref.getDownloadURL();
    print(updateUrl);
    taskSnapshot.ref.getDownloadURL().then(
          (value) => print("Done: $value"),
    );
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(doc.id)
        .set({
      'url': updateUrl,
      'email':email,
      'firstname':firstname,
      'middlename':middlename,
      'lastname':lastname,
      'address':address,
      'gender':gender,
      'age':age,
      'birthday':birthday,
      'contact':contact,
      'password':password,
      'patientID':doc.id

    })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));


}
  @override
  Widget build(BuildContext context){
    return Container(

        width:MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height,
    decoration: BoxDecoration(
    image: DecorationImage(image: AssetImage("assets/background.png"), fit: BoxFit.cover),
    ),
    child:
      SingleChildScrollView(
        child:Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child:
            Container(
                width: 380,
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
              ,),
          Center(
            child:
          Container(
            width: MediaQuery.of(context).size.width*0.87, height: 60,
            margin: EdgeInsets.only(top:10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xff259B9A),
            ),
            child:Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff259B9A)),
                    elevation: MaterialStateProperty.all(0),
                  ),
                  onPressed: (){

                _showChoiceDialog(context);
              }
                  , child: Text("Upload Picture",
                    style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                  )
              ),
            ),),),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: firstNameController,
                decoration: InputDecoration(
                    labelText: "First Name",
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
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
                controller: middleNameController,
                decoration: InputDecoration(
                    labelText: "Middle Name",
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
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
                controller: lastNameController,
                decoration: InputDecoration(
                    labelText: "Last Name",
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
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
                controller: addressController,
                decoration: InputDecoration(
                    labelText: "Address",
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                ),
                validator: (value){
                  if(value == null || value.isEmpty){
                    return "Address should not be empty.";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                    labelText: "Email Address",
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                ),
                validator: validateEmail,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: contactController,
                decoration: InputDecoration(
                    labelText: "Contact",
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                ),

              ),
            ),
            /*Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: birthController,
                decoration: InputDecoration(
                    labelText: "Birthday"
                ),

              ),
            ),*/
            DateTimePicker(
              type: DateTimePickerType.date,
              dateMask: 'd MMM, yyyy',
              initialValue: null,
              firstDate: DateTime(1800),
              lastDate: DateTime(2100),
              icon: Icon(Icons.event),
              dateLabelText: 'Date',

              onChanged: (val){
                setState(() {
                  birthdate = val;

                });
              },
              validator: (val) {
                print(val);
                return null;
              },
              onSaved: (val){
                setState(() {
                  birthdate = val;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: ageController,
                decoration: InputDecoration(
                    labelText: "Age",
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                ),

              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children:[
                  Text(
                    'Male',
                    style: new TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),
                  ),

                  Radio(
                    value: 1,
                    groupValue: id,
                    onChanged: (val) {
                      setState(() {
                          gender = 'Male';
                          id = 1;
                      });
                    },
                  ),

                  Text(
                    'Female',
                    style: new TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),
                  ),

                  Radio(
                    value: 2,
                    groupValue: id,
                    onChanged: (val) {
                      setState(() {
                        gender = 'Female';
                        id = 2;
                      });
                    },
                  ),
                ]
              )
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                    labelText: "Password",
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
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
              child: TextFormField(
                obscureText: true,
                controller: confirmPasswordController,
                decoration: InputDecoration(
                    labelText: "Confirm Password",
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                ),
                validator: (value){
                  if(value == null || value.isEmpty){
                    return "Password should not be empty.";
                  }
                  else if(value != passwordController.text){
                    return "Password should match.";
                  }
                  return null;
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width*0.41, height: 60,
                    margin: EdgeInsets.only(top:10,bottom:10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Padding(

                  padding: const EdgeInsets.all(3.0),
                  child: ElevatedButton(

                      style:ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Color(0xff00ABE1)),
                        elevation: MaterialStateProperty.all(0),


                      ),
                      onPressed: (){
                    if(_formKey.currentState.validate()){
                      saveUsers(context,emailController.text,
                      firstNameController.text,middleNameController.text, lastNameController.text,
                      gender,ageController.text,birthdate,contactController.text,
                     passwordController.text,addressController.text);

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Successfully Registered")));
                      Navigator.pop(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                   }

                  }
                      , child: Text("Save")),
                )),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: ElevatedButton(onPressed: (){
                //     Navigator.pop(context);
                //   }
                //       , child: Text("Back")),
                // ),
                Container(
                  width: MediaQuery.of(context).size.width*0.41, height: 60,
                  margin: EdgeInsets.only(top:10,bottom:10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child:
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Color(0xff00ABE1)),
                        elevation: MaterialStateProperty.all(0),
                      ),
                      onPressed: (){
                    firstNameController.text = "";
                    lastNameController.text = "";
                    emailController.text = "";
                    passwordController.text = "";
                    confirmPasswordController.text = "";
                  }
                      , child: Text("Clear")),
                ),)

              ],
            ),
            Center(child:
            Container(
              width: MediaQuery.of(context).size.width*0.87, height: 60,
              margin: EdgeInsets.only(top:10,bottom:10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,

              ),
              child:
              Padding(
                padding: const EdgeInsets.all(3.0),
                child:  ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff00ABE1)),
                      elevation: MaterialStateProperty.all(0),
                    ),
                    onPressed: (){
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      );
                    }
                    , child: Text("LOGIN",
                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                )

                ),
              ),
            ),),

          ],
        )
    ),
      )
    );
  }
}