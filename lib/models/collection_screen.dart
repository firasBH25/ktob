import 'package:flutter/material.dart';

class collection_screen extends StatelessWidget {
  static const routeName ='/collection';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My Book Collection"),
          centerTitle: true,
        ),
        body: Center(
          child: Text(
              "My Books",
              style: TextStyle(
                fontSize:50,
                fontWeight: FontWeight.bold,

              )
          ),

        )
    );
  }
}