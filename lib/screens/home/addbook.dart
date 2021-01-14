import 'package:flutter/material.dart';
import "dart:io";
import 'package:gx_file_picker/gx_file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddBook extends StatefulWidget {
  @override
  _AddBook createState() => _AddBook();
}

class _AddBook extends State<AddBook> {
  UploadTask uploadTask;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload your book"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          File pdfpath = await getPdf();
          List<String> test = pdfpath.path.split('/');
          Reference pdfStorageRef = FirebaseStorage.instance
              .ref()
              .child('booksPdf')
              .child(test[test.length - 1]);
          if (pdfpath != null) {
            uploadTask = pdfStorageRef.putFile(pdfpath);
            print("upload done");

            uploadTask.snapshotEvents.listen((event) {
              if (event.state == TaskState.success) {
                print("upload done");
              } else {
                print("still uploading");
              }
            });
          }
        },
        child: Icon(
          Icons.add,
          color: Colors.white12,
        ),
      ),
    );
  }

  Future<File> getPdf() async {
    File file = await FilePicker.getFile();
    print(file.path);
    return file;
    //savePdf(file.readAsBytesSync(),fileName);
  }
}
/*
uploadTask = storageRef.putFile(sampleImage);
                      uploadTask.snapshotEvents.listen((event) async {
                        if(event.state==TaskState.success){
                          widget.imageUrl = await storageRef.getDownloadURL();
                          widget.books.doc((test.id)).update({"imageUrl":widget.imageUrl}).then((value){
                          showDialog(
                            context: context,
                            builder: ((_) => 
                            AlertDialog(
                              title: Text("Book added successfully"),
                              content: Text("Click OK to continue"),
                              actions: [
                                FlatButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "OK",
                                    style: TextStyle(color: Colors.cyan),
                                  ),
                                ),
                              ],
                            )
                          )); 
                          }
                          );
                        }else{
                          setState((){
                            widget.currentPicture = Container(
                              color: Colors.blue,
                              child: SpinKitThreeBounce(color: Colors.white,size: 45,),
                            );
                          });
                        }
                      });*/
