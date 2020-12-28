import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/Models/Mission.dart';
import 'package:todo_list/Utils/DataBaseHelper.dart';

class MissionGive extends StatefulWidget {
  final String appBar;
  final Mission mission;

MissionGive (this.mission, this.appBar);

  @override
  State<StatefulWidget> createState() {
    return MissionGiveState(this.mission, this.appBar);
  }
}

class MissionGiveState extends State<MissionGive> {

  DatabaseHelper Helper = DatabaseHelper();

  String appBar;
  Mission mission;

  TextEditingController TitleController = TextEditingController();

  MissionGiveState(this.mission, this.appBar);

  @override
  Widget build(BuildContext context) {
    TextStyle TextStyle = Theme.of(context).textTheme.title;

    TitleController.text = mission.Address;

    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(appBar),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  moveToLastScreen();
                }),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
   
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: TitleController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint(' Something has changed in Title Text');
                      updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: 'Title mission',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0))),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Save',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Button save clicked");
                              _save();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void updateTitle() {
    mission.Address = TitleController.text;
  }
  void _save() async {
    moveToLastScreen();

   mission.Input = 0;
    int result;
    if (mission.Id != null) {

      result = await Helper.updatemissionCompleted(mission);
    } else {
      result = await Helper.insertmission(mission);
    }

    if (result != 0) {
     
      _showAlertDialog('Status', ' Successfully');
    } else {
      _showAlertDialog('Status', 'Error');
    }
  }

  void _delete() async {
    moveToLastScreen();

    if (mission.Id == null) {
      _showAlertDialog('Status', 'No mission was deleted');
      return;
    }

    int result = await Helper.deletemission (mission.Id);
    if (result != 0) {
      _showAlertDialog('Status', 'Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Deleting');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
