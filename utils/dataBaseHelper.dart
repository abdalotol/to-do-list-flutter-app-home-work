import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:todo_list/Models/Mission.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String missionTable = 'mission_table';
  String colId = 'Id';
  String colAddress = 'Address';
  String colInput = 'Input';

  DatabaseHelper._createInstance(); 
  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); 
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
   
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'mission.db';

 
    var missionDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return missionDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $missionTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colAddress TEXT, $colInput INTEGER DEFAULT 1)');
  }


  Future<List<Map<String, dynamic>>> getAllMissionMapList() async {
    Database db = await this.database;

    var result = await db.rawQuery('SELECT * FROM $missionTable ');
    return result;
  }

 
  Future<List<Map<String, dynamic>>> getCompleteMissionMapList() async {
    Database db = await this.database;

    var result =
        await db.rawQuery('SELECT * FROM $missionTable WHERE $colInput= 1');
    return result;
  }

 
  Future<List<Map<String, dynamic>>> getInCompleteMissionMapList() async {
    Database db = await this.database;

    var result =
        await db.rawQuery('SELECT * FROM $missionTable WHERE $colInput= 2');
    return result;
  }

  
  Future<int> insertmission (Mission mission) async {
    Database db = await this.database;
    var result = await db.insert(missionTable, mission.toMap());
    return result;
  }

 
  Future<int> updatemissionInCompleted(Mission mission) async {
    var db = await this.database;
    var result = await db
        .update(missionTable, mission.toMap(), where: '$colInput = ?', whereArgs: [2]);
    return result;
  }

  Future<int> updatemissionCompleted(Mission mission) async {
    var db = await this.database;
    var result = await db
        .update(missionTable, mission.toMap(), where: '$colInput = ?', whereArgs: [2]);
    return result;
  }

 
  Future<int> deletemission(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $missionTable WHERE $colId = $Id');
    return result;
  }


  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $missionTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  
  Future<List<Mission>> getmissionList(int Input) async {
    switch (Input) {
      case 1:
        {
          var missionMapList = await getCompleteMissionMapList();
          int count =
              missionMapList.length;

          List<Mission> missionList = List<Mission>();

          for (int i = 0; i < count; i++) {
            missionList.add(Mission.fromMapObject(missionMapList[i]));
          }

          return missionList; 
        }
        break;
      case 2:
        {
          var missionMapList = await getInCompleteMissionMapList();
          int count =
             missionMapList.length; 

          List<Mission> missionList = List<Mission>();
          for (int i = 0; i < count; i++) {
            missionList.add(Mission.fromMapObject(missionMapList[i]));
          }

          return missionList; 
        }
        break;
      default:
        {
          var missionMapList = await getAllMissionMapList();
          int count =
              missionMapList.length;
          List<Mission> missionList = List<Mission>();
         
          for (int i = 0; i < count; i++) {
           MissionList.add(Mission.fromMapObject(missionMapList[i]));
          }

          return missionList;
        }
        break;
    }
  }
}
