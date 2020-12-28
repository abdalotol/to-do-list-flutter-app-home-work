import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:todo_list/Models/Mission.dart';
import 'package:todo_list/Utils/DataBaseHelper.dart';

class MissionList extends StatefulWidget {
  int Input= 0;
  MissionList(int Input) {
    this.Input =Input;
  }
  @override
  _MissionListState createState() => _MissionListState();
}

class _MissionListState extends State<MissionList> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  List<Mission> MissionList;

  int count = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    if (MissionList == null) {
     MissionList = List<Mission>();
      updateListView();
    }

    return Center(
      child: getMissionListView(),
    );
  }

  ListView getMissionListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTitle(
            leading: CircleAvatar(
              backgroundColor: Colors.amber,
              child: Text(getFirstLetter(this.MissionList[position].Address),
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            title: Text(this.MissionList[position].Address,
                style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onTap: () {
                    _delete(context, MissionList[position]);
                  },
                ),
                Checkbox(
                  value: MissionList[position].Input == 2,
                  onChanged: (value) {
                    if (MissionList[position].Input == 1) {
                      _changeTypeCompleted(context, MissionList[position]);
                    } else if (MissionList[position].Input == 2) {
                      _changeTypeInCompleted(context, MissionList[position]);
                    }
                  },
                )
              ],
            ),
            onTap: () {
              debugPrint("ListTitle Tapped");
              // navigateToDetail(this.MissionList[position], 'Edit');
            },
          ),
        );
      },
    );
  }

  getFirstLetter(String title) {
    return title.substring(0, 2);
  }

  void _delete(BuildContext context, Mission mission) async {
    int result = await databaseHelper.deletemission (Mission.Id);
    if (result != 0) {
      _showSnackBar(context, ' Deleted Successfully');
      updateListView();
    }
  }

  void _changeTypeCompleted(BuildContext context, Mission mission) async {
    int result = await databaseHelper.updatemissionCompleted(mission);
    if (result != 0) {
      _showSnackBar(context, ' Completed Successfully');
      updateListView();
    }
  }

  void _changeTypeInCompleted(BuildContext context,Mission mission) async {
    int result = await databaseHelper.updatemissionInCompleted(mission);
    if (result != 0) {
      _showSnackBar(context, ' InCompleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Mission>> todoListFuture = databaseHelper.getmissionList(0);
      todoListFuture.then((todoList) {
        setState(() {
          this.MissionList = MissionList;
          this.count = MissionList.length;
        });
      });
    });
  }
}
