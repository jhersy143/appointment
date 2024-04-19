import 'dart:ffi';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:path/path.dart';
import 'package:appointment/doctor/doctorlogin_screen.dart';

class DoctorSignupWidget extends StatefulWidget{
  @override
  DoctorSignupWidgetState createState(){
    return DoctorSignupWidgetState();
  }
}

class DoctorSignupWidgetState extends State<DoctorSignupWidget>{
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
  TextEditingController specializationController = TextEditingController();
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
    gender = 'Male';
    id= 1;
    url = 'https://firebasestorage.googleapis.com/v0/b/cyclista-f4d3b.appspot.com/o/profilepic%2Fdefault.jpg?alt=media&token=ddda3cd3-47af-4878-8584-006f2f6c74dd';

  }
  Future saveUsers(BuildContext context,
      String email, String firstname,String middlename,String lastname,
      String gender,String age,String birthday,String contact,String password,String specialization) async {
    String fileName = basename(imageFile.path);
    FirebaseStorage firebaseStorageRef =  FirebaseStorage.instance;
    UploadTask uploadTask =  firebaseStorageRef.ref().child('profilepic/$fileName').putFile(File(imageFile.path));
    var doc =  FirebaseFirestore.instance.collection('Doctors').doc();
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    updateUrl = await taskSnapshot.ref.getDownloadURL();
    print(updateUrl);
    taskSnapshot.ref.getDownloadURL().then(
          (value) => print("Done: $value"),
    );
    await FirebaseFirestore.instance
        .collection('Doctors')
        .doc(doc.id)
        .set({
      'url': updateUrl,
      'email':email,
      'firstname':firstname,
      'middlename':middlename,
      'lastname':lastname,
      'gender':gender,

      'contact':contact,
      'password':password,
      'specialization':specialization,
      'doctorID':doc.id
    })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));


  }
  @override
  Widget build(BuildContext context){
    return
      SingleChildScrollView(
        child:Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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


                )
                ,
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(onPressed: (){

                    _showChoiceDialog(context);
                  }
                      , child: Text("Upload Picture")),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
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
                    controller: lastNameController,
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
                    controller: middleNameController,
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
                    controller: specializationController,
                    decoration: InputDecoration(
                        labelText: "Specialization"
                    ),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "Specialization should not be empty.";
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
                        labelText: "Email Address"
                    ),
                    validator: validateEmail,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: contactController,
                    decoration: InputDecoration(
                        labelText: "Contact"
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
                            onChanged: (val) {
                              setState(() {
                                gender = 'Male';
                                id = 1;
                              });
                            },
                          ),

                          Text(
                            'Female',
                            style: new TextStyle(fontSize: 15.0),
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
                  child: TextFormField(
                    obscureText: true,
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                        labelText: "Confirm Password"
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(onPressed: (){
                        if(_formKey.currentState.validate()){
                          saveUsers(context,emailController.text,
                              firstNameController.text,middleNameController.text, lastNameController.text,
                              gender,ageController.text,birthController.text,contactController.text,
                             passwordController.text,specializationController.text);

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Successfully Registered")));
                          Navigator.pop(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DoctorLoginScreen(),
                            ),
                          );
                        }

                      }
                          , child: Text("Save")),
                    ),
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
                        firstNameController.text = "";
                        lastNameController.text = "";
                        emailController.text = "";
                        passwordController.text = "";
                        confirmPasswordController.text = "";
                      }
                          , child: Text("Clear")),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(onPressed: (){
                        Navigator.pop(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DoctorLoginScreen(),
                          ),
                        );
                      }
                          , child: Text("Login")),
                    )
                  ],
                ),

              ],
            )
        ),
      );
  }
}