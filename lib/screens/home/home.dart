import 'package:bookini/models/UserData.dart';
import 'package:bookini/models/brew.dart';
import 'package:bookini/screens/home/addbook.dart';
import 'package:bookini/screens/home_screen.dart';
import 'package:bookini/screens/profile/Profile.dart';
import 'package:bookini/screens/settings/SettingsPage.dart';
import 'package:flutter/material.dart';
import 'package:bookini/services/database.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  int globalIndex = 0;
  int _currentIndex = 0;
  final List<StatefulWidget> tabs = [
    HomeScreen(),
    AddBook(),
    Profile(),
    SettingsPage()
  ];

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<MyData>>.value(
        value: DatabaseService().users,
        child: StreamProvider<List<Brew>>.value(
          value: DatabaseService().brews,
          child: Scaffold(
              backgroundColor: Colors.brown[50],
              appBar: AppBar(
                backgroundColor: Colors.brown[50],
                elevation: 0.0,
                actions: <Widget>[
                  FlatButton.icon(
                    icon: Icon(Icons.settings),
                    label: Text(''),
                    onPressed: () async {
                      setState(() {
                        globalIndex = 2;
                      });
                    },
                  ),
                ],
              ),
              body: tabs[globalIndex],
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _currentIndex,
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: "home",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.add),
                    label: "Add book",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: "Profile",
                  )
                ],
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                    globalIndex = index;
                  });
                },
              )),
        ));
  }
}
