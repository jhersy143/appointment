import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// database table and column names
final String tableAppointment= 'appointment';
final String columnId = '_id';
final String columnLastName = 'last_name';
final String columnFirstName = 'first_name';
final String columnEmail = 'email';
final String columnPassword = 'password';
final String columndetails = 'details';
final String columnappointment = 'appointment';

// data model class
class Appointment {

  int id;
  String last_name;
  String first_name;
  String email;
  String password;
  String details;
  String appointment;
  int count;
  Appointment();


  // convenience constructor to create a Word object
  Appointment.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    last_name = map[last_name];
    first_name = map[first_name];
    email = map[email];
    password = map[password];
    appointment = map[appointment];
    details = map[details];
  }
  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnLastName: last_name,
      columnFirstName: first_name,
      columnEmail: email,
      columnPassword: password,
      columnappointment: appointment,
      columndetails: details

    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}

// singleton class to manage the database
class DatabaseHelper {

  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "appointment.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableAppointment (
                $columnId INTEGER PRIMARY KEY,
                $columnLastName TEXT NOT NULL,
                $columnFirstName TEXT NOT NULL,
                $columnEmail TEXT NOT NULL,
                $columnPassword TEXT NOT NULL,
                $columnappointment NUMBER NOT NULL,
                $columndetails DATE NOT NULL
              )
              ''');
  }

  // Database helper methods:

  Future<int> insert(Appointment appointment) async {
    Database db = await database;
    int id = await db.insert(tableAppointment, appointment.toMap());
    return id;
  }
  Future<int> updateData(Appointment appointment) async {
    var db = await this.database;
    var result = await db.update(tableAppointment, appointment.toMap(), where: '$columnId  = ?', whereArgs: [appointment.id]);
    return result;
  }
  Future<int> deleteData(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $tableAppointment WHERE  $columnId  = $id');
    return result;
  }
Future<Appointment> queryAccount(String email, String password) async {
    Database db = await database;
    List<Map> maps = await db.query(tableAppointment,
        columns: [columnId, columnLastName, columnFirstName, columnEmail, columnPassword],
        where: '$columnEmail = ? AND $columnPassword = ?',
        whereArgs: [email, password]);
    if (maps.length > 0) {
      Appointment apointment = Appointment();
      apointment.last_name = maps.first["last_name"];
      apointment.first_name = maps.first["first_name"];
      apointment.email = maps.first["email"];
      apointment.password = maps.first["password"];
      apointment.appointment  = maps.first["appointment "];
      apointment.details = maps.first["details"];
      return apointment;
    }
    return null;
  }



  Future<List<Appointment>> queryAllAccount() async {
    Database db = await database;
    List<Map> maps = await db.query(tableAppointment,
        columns: [columnId, columnLastName, columnFirstName, columnEmail, columnPassword],
        );
    if (maps.length > 0) {
      List<Appointment> list_acct = List<Appointment>();

     for(int i = 0; i < maps.length; i++){
       Appointment customer = Appointment();
       customer.last_name = maps[i]["last_name"];
       customer.first_name = maps[i]["first_name"];
       customer.email = maps[i]["email"];
       customer.password = maps[i]["password"];
       list_acct.add(customer);
     }

     return list_acct;
    }
    return null;
  }

}