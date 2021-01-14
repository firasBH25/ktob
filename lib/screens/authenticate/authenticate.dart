import 'package:bookini/models/userName.dart';
import 'package:bookini/screens/authenticate/register.dart';
import 'package:bookini/screens/authenticate/sign_in.dart';
import 'package:bookini/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;
  void toggleView(){
    
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView:  toggleView);
    } else {
      return StreamProvider<List<UserName>>.value(
      value:DatabaseService().username ,
      child :Register(toggleView:  toggleView));
    }
  }
}