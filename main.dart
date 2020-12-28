import 'package:flutter/material.dart';
import 'package:todo_list/Screens/MissionList.dart';

import 'Models/Mission.dart';
import 'Screens/MissionGive.dart';

void main() {
  runApp(MissionApp());
}

class MissionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Mission',
      theme: ThemeData.light(),
      home: TabsScreen(),
    );
  }
}

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Mission'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'All Mission'),
              Tab(text: 'Complete Mission'),
              Tab(text: 'InComplete Mission')
            ],
          ),
        ),
        body: TabBarView(
          children: [MissionList(0), MissionList(1), MissionList(2)],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            debugPrint('FAB clicked');
            navigateToDetail(Mission('', 0), 'Add Mission');
          },
          tooltip: 'Add Mission',
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  void navigateToDetail(Mission todo, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MissionDetail(todo, title);
    }));
  }
}
