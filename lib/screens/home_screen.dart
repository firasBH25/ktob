import 'dart:io';

import 'package:bookini/models/collection_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:bookini/screens/home/ReadBook.dart';
import 'package:bookini/screens/widgets/two_side_rounded_button.dart';
import 'package:bookini/screens/widgets/reading_card_list.dart';
import 'package:bookini/services/database.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<File> getFileFromUrl(String url, {name}) async {
    var fileName = 'testonline';
    if (name != null) {
      fileName = name;
    }
    try {
      var data = await http.get(url);
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/" + fileName + ".pdf");
      print(dir.path);
      File urlFile = await file.writeAsBytes(bytes);
      print(urlFile.path);
      return urlFile;
    } catch (e) {
      throw Exception("Error opening url file");
    }
  }

  Future<List<ReadingListCard>> getBooksData(int mode) async {
    //mode = 0 >>> reading today
    //mode !=0 >>> recently added
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    List<ReadingListCard> returnedValue = [];
    await DatabaseService().booksCollection.get().then((value) {
      value.docs.forEach((element) {
        if (mode == 0) {
          if (element.get("addedDate") == formatter.format(DateTime.now()))
            returnedValue.add(ReadingListCard(
              auth: element.get("auth"),
              image: element.get("imageUrl"),
              title: element.get("title"),
              rating: double.parse(element.get("rating").toString()),
              pressDetails: null,
              pressRead: () async {
                getFileFromUrl(element.get("bookUrl"),
                        name: element.get("title"))
                    .then(
                  (value) => {
                    if (value != null)
                      {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReadBook(
                                      urlPDFPath: value.path,
                                    )))
                      }
                  },
                );
              },
            ));
        } else {
          if (element.get("addedDate") != formatter.format(DateTime.now()))
            returnedValue.add(ReadingListCard(
              auth: element.get("auth"),
              image: element.get("imageUrl"),
              title: element.get("title"),
              rating: double.parse(element.get("rating").toString()),
              pressDetails: null,
              pressRead: () async {
                getFileFromUrl(element.get("bookUrl"),
                        name: element.get("title"))
                    .then(
                  (value) => {
                    if (value != null)
                      {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReadBook(
                                      urlPDFPath: value.path,
                                    )))
                      }
                  },
                );
              },
            ));
        }
      });
    });
    return returnedValue;
  }

  void requestPersmission() async {
    await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  }

  @override
  void initState() {
    super.initState();
    requestPersmission();
  }

  @override
  Widget build(BuildContext context) {
    /*DatabaseService().updateBooksDataBase(
        "https://firebasestorage.googleapis.com/v0/b/bookini-6c550.appspot.com/o/910wQjboTML.jpg?alt=media&token=5cca1ea7-0eea-4655-914d-0fd5a031aca6",
        "Voltaire",
        "Candide",
        5);
*/
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.brown[50],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  /* image: DecorationImage(
                    image: AssetImage("assets/images/1_book.png"),
                    alignment: Alignment.topCenter,
                    fit: BoxFit.fitWidth,
                  ),*/
                  ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: size.height * .1),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.display1,
                        children: [
                          TextSpan(text: "Recently "),
                          TextSpan(
                              text: "added ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                          TextSpan(text: "books"),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: FutureBuilder(
                          future: getBooksData(0),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<ReadingListCard>> snapshot) {
                            if (snapshot.hasData) {
                              return Row(
                                children: snapshot.data,
                              );
                            } else {
                              return Text("test2");
                            }
                          })),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.display1,
                            children: [
                              TextSpan(
                                text: "available ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: " books",
                              ),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: FutureBuilder(
                                future: getBooksData(1),
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<ReadingListCard>>
                                        snapshot) {
                                  if (snapshot.hasData) {
                                    return Row(
                                      children: snapshot.data,
                                    );
                                  } else {
                                    return Text("test2");
                                  }
                                })),
                        RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.display1,
                            children: [
                              TextSpan(text: "Continue "),
                              TextSpan(
                                text: "reading...",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: 80,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(38.5),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 10),
                                blurRadius: 33,
                                color: Color(0xFFD3D3D3).withOpacity(.84),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(38.5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 30, right: 20),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "check my Book Collection",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                "",
                                                style: TextStyle(),
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Text(
                                                  "",
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                            ],
                                          ),
                                        ),
                                        Image.asset(
                                          "assets/images/1_book.png",
                                          width: 55,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 7,
                                  width: size.width * .65,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(collection_screen.routeName);
                },
                child: new Container()),
          ],
        ),
      ),
    );
  }

  Container bestOfTheDayCard(Size size, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      width: double.infinity,
      height: 245,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: 24,
                top: 24,
                right: size.width * .35,
              ),
              height: 230,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFFEAEAEA).withOpacity(.45),
                borderRadius: BorderRadius.circular(29),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Text(
                      "New York Time Best For 11th March 2020",
                      style: TextStyle(
                        fontSize: 9,
                      ),
                    ),
                  ),
                  Text(
                    "How To Win \nFriends &  Influence",
                    style: Theme.of(context).textTheme.title,
                  ),
                  Text(
                    "Gary Venchuk",
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 10.0),
                        ),
                        Expanded(
                          child: Text(
                            "When the earth was flat and everyone wanted to win the game of the best and people….",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Image.asset(
              "assets/images/2_book.png",
              width: size.width * .37,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: SizedBox(
              height: 40,
              width: size.width * .3,
              child: TwoSideRoundedButton(
                text: "Read",
                radious: 24,
                press: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
