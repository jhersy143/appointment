
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../flutter_session.dart';
import 'appointmentall_screen.dart';
import 'historyconsult_screen.dart';
import 'historyappointment_screen.dart';
class HistoryPageWidget extends StatefulWidget{
  @override
  HistoryPageWidgetState createState(){
    return HistoryPageWidgetState();
  }
}

class HistoryPageWidgetState extends State<HistoryPageWidget>{

  var session = FlutterSession();

  @override
  Widget build(BuildContext context){
    return DecoratedBox(
        decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/background.png"), fit: BoxFit.cover),
    ),
    child:Column(
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        Center(
          child:
        Container(
          width: 250, height: 60,
          margin: EdgeInsets.only(bottom:5,top:100),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child:
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff00ABE1)
                      ),
                        elevation: MaterialStateProperty.all(0),
                      ),
                      onPressed: (){
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context)=>HistoryAppointmentAllScreen()),
                        );
                      }
                      , child: Text("APPOINTMENT")),
                ),
              ),

        ),
        Center(
            child:
        Container(
          width: 250, height: 60,
          margin: EdgeInsets.only(bottom:5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child:
           Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff00ABE1)),
                  elevation: MaterialStateProperty.all(0),
                ),
                onPressed: (){
              Navigator.push(context,
                MaterialPageRoute(builder: (context)=>HistoryConsultPageScreen()),
              );
            }
                , child: Text("CONSULTATION")),
          ),
          )
        ),


        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: ElevatedButton(onPressed: (){
        //     Navigator.pop(context);
        //   }
        //       , child: Text("Back")),
        // )
      ],

    ));
  }
}