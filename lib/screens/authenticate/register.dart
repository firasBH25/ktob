import 'package:bookini/models/userName.dart';
import 'package:bookini/services/auth.dart';
import 'package:bookini/services/database.dart';
import 'package:bookini/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bookini/shared/constants.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({ this.toggleView });

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final CollectionReference userNamesCollection = FirebaseFirestore.instance.collection('Usernames');
  bool loading = false ;

  // text field state
  String email = '';
  String password = '';
  String passwordVerif = '';
  String userName = '';
  String error = '';


  @override
  Widget build(BuildContext context) {
    return  loading ? Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: "User Name"),
                validator: (val) => val.length < 6 ? 'Enter a userName' : null,
                onChanged: (val) {
                  setState(() => userName = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: "E-mail"),
                validator: (val) => val.isEmpty ? 'Enter an email' : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: "Password"),
                obscureText: true,
                validator: (val) => val.length < 6 ? 'Enter a password 6+ chars long' : null,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: "Enter passowrd again"),
                obscureText: true,
                validator: (val) => val != password ? 'Enter the same password' : null,
                onChanged: (val) {
                  setState(() => passwordVerif = val);
                },
              ),
              SizedBox(height: 20.0),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RaisedButton(
                color: Colors.pink[400],
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if(_formKey.currentState.validate()){
                     setState(() {
                      loading = true ;
                    });
                    //final userdata = Provider.of<List<UserName>>(context);
                    //if (userdata.where((element) => element.userName == userName).isEmpty)
                    //{  
                    //DatabaseService(uid: "none").updateUserName(userName, true);
                    dynamic result = await _auth.registerWithEmailAndPassword(email, password ,userName  );
                    if(result == null) {
                      //DatabaseService(uid: "none").updateUserName(userName, false);
                      setState(() {
                        error = 'Sign up error';
                        loading = false ;
                      });
                    }
                    //}

              
                  }
                }
              ),
              RaisedButton(
                color: Colors.white,
                child: Text(
                  'Sign In',
                  style: TextStyle(color: Colors.black54),
                ),
                onPressed: () => widget.toggleView(),



              )
                  ],

              ),
              
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}