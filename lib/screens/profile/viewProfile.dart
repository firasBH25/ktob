import 'package:bookini/models/UserData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'EditProfile.dart';


class ViewProfilePage extends StatefulWidget {
  final Function toggleView;
  ViewProfilePage({ this.toggleView });
  @override
  _ViewProfilePageState createState() => _ViewProfilePageState();
} 


class _ViewProfilePageState extends State<ViewProfilePage> {
  bool editMode = false ;
  
  @override
  Widget build(BuildContext context) {
    final userdata = Provider.of<List<MyData>>(context);
    MyData user  = userdata[0] ;
    return  editMode ?EditProfilePage : Scaffold(
      backgroundColor: Colors.brown[50],
      body: Container(
      padding: EdgeInsets.only(left: 16, top: 25, right: 16),
      child: ListView(
        children:[
          Text(
                "My Profile",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
          SizedBox(
                height: 15,
              ),
          Center(
            child: Stack(
              children: [
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 4,
                          color: Theme.of(context).scaffoldBackgroundColor),
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: 2,
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.1),
                            offset: Offset(0, 10))
                      ],
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png",
                          ))),
                ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 4,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        color: Colors.green,
                      ),
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                        
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(
              height: 35,
            ),
          buildTextField("Full Name", user.fullName),
          buildTextField("Rating", user.rating.toString()),
          buildTextField("Location", user.location),
          buildTextField("Phone Number", user.phone),
          buildTextField("Bio", user.bio),
          SizedBox(
              height: 35,
            ),
        
              RaisedButton(
                    onPressed: () => widget.toggleView()
                    ,
                    color: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      "Edit Profile",
                      style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.white),
                    ),
                    )                    
        ]
      ),
      ),
    );        
  }

Widget buildTextField(
  String labelText, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: Text(
        labelText +" : "+text,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),        
      ),      
    );
}
}
