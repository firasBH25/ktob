import 'package:bookini/screens/profile/EditProfile.dart';
import 'package:bookini/screens/profile/viewProfile.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  bool editMode = false;
  void toggleView(){
    
    setState(() => editMode = !editMode);
  }
  

  @override
  Widget build(BuildContext context) {
    if (editMode) {
      return EditProfilePage(toggleView:  toggleView );
    } else {
      return ViewProfilePage(toggleView:  toggleView);
    }
  }
}