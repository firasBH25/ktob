import 'package:bookini/models/UserData.dart';
import 'package:bookini/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class EditProfilePage extends StatefulWidget {
  final Function toggleView;
  EditProfilePage({ this.toggleView });
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}


class _EditProfilePageState extends State<EditProfilePage> {
    
    bool showPassword = false;
    final _formKey = GlobalKey<FormState>();
    bool loading = false ;

  // text field state
    String fullname = '';
    String location = '';
    String phone = '';
    String bio = '';
    String error = '';
    @override
    
    Widget build(BuildContext context) {
      final userdata = Provider.of<List<MyData>>(context);
      MyData user  = userdata[0] ;
      return Scaffold(
        backgroundColor: Colors.brown[50],
        body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children:[
            Text(
                  "Edit Profile",
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
            Form(child:Column(
                key:_formKey,
                  children: <Widget>[
                SizedBox(height: 20.0),
                TextFormField
                (decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 3),
                  labelText: "Full name",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: user.fullName,
                  hintStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
            ),
            
                validator: (val) => val.isEmpty ? 'Enter a userName' : null,
                onChanged: (val) {
                  setState(() => fullname = val);
                }
        )
        ,SizedBox(height: 20.0),
        TextFormField
                (decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 3),
                  labelText: "Location",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: user.location,
                  hintStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  )
            ),
                onChanged: (val) {
                  setState(() => location = val);
                }
        )
        ,SizedBox(height: 20.0),
        TextFormField
                (decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 3),
                  labelText: "Phone Number",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: user.phone,
                  hintStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  )
            ),
            
                validator: (val) => (int.parse(val)>9999999)&(int.parse(val)>100000000) ? null : 'Enter a valid phone number',
                onChanged: (val) {                                            
                  setState(() => phone = val);
                }
        )
        ,SizedBox(height: 20.0),
        TextFormField
                (decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 3),
                  labelText: "Bio",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: user.bio,
                  hintStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  )
            ),
                onChanged: (val) {
                  setState(() => bio = val);
                }
             ),
        SizedBox( height: 35,),
        RaisedButton(
          onPressed: () async {
            dynamic result = await AuthService().updateProfile(fullname, location, phone, bio);
            if(result == null) {
            setState(() {
              error = 'error !';
              });
            }
          }
          ,  
          color: Colors.green,
          padding: EdgeInsets.symmetric(horizontal: 50),
          elevation: 2,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          child: Text(
            "SAVE",
            style: TextStyle(
                fontSize: 14,
                letterSpacing: 2.2,
                color: Colors.white),
          ),
          )

              ]
              )
              )
            ,                          
          ]
        ),
        ),
      );
    }
  }