import 'package:bookini/models/UserData.dart';
import 'package:bookini/models/brew.dart';
import 'package:bookini/models/userName.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference brewCollection =
      FirebaseFirestore.instance.collection('brews');
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference userNameCollection =
      FirebaseFirestore.instance.collection('Usernames');
  final CollectionReference booksCollection =
      FirebaseFirestore.instance.collection('books');
  Future<void> updateBrewData(String sugars, String name, int strength) async {
    return await brewCollection.doc(uid).set({
      'sugars': sugars,
      'name': name,
      'strength': strength,
    });
  }

  Future<void> updateBooksDataBase(String imageUrl, String bookUrl, String auth,
      String title, double rating) async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return await booksCollection.doc(uid).set({
      'imageUrl': imageUrl,
      'bookUrl': bookUrl,
      'auth': auth,
      'title': title,
      'rating': rating,
      'addedDate': formatter.format(DateTime.now())
    });
  }

  Future<void> updakteUserData(String fullName, String location, String phone,
      String bio, String userName) async {
    if (userName == '') {
      return await usersCollection.doc(uid).set({
        'fullName': fullName,
        'rating': 0,
        'location': location,
        'phone': phone,
        'bio': bio,
      });
    } else {
      return await usersCollection.doc(uid).set({
        'fullName': fullName,
        'rating': 0,
        'location': location,
        'phone': phone,
        'bio': bio,
        'userName': userName,
      });
    }
  }

  Future<void> updateUserName(String username, bool existes) async {
    return await userNameCollection.doc(username).set({
      'existes': existes,
    });
  }

  // brew list from snapshot
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      //print(doc.data);
      return Brew(
          name: doc.data()['name'] ?? '',
          strength: doc.data()['strength'] ?? 0,
          sugars: doc.data()['sugars'] ?? '0');
    }).toList();
  }

  // User Data from snapshot
  List<MyData> _userDataFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return MyData(
          fullName: doc.data()['fullName'] ?? '',
          rating: doc.data()['rating'] ?? 0,
          location: doc.data()['location'] ?? '',
          phone: doc.data()['phone'] ?? "",
          bio: doc.data()['bio'] ?? '');
    }).toList();
  }

  List<UserName> _userNameFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserName(
        userName: doc.id ?? '',
      );
    }).toList();
  }

// get Users stream
  Stream<List<MyData>> get users {
    return usersCollection.snapshots().map(_userDataFromSnapshot);
  }

  // get brews stream
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  // check UserName
  Stream<List<UserName>> get username {
    return userNameCollection.snapshots().map(_userNameFromSnapshot);
  }
}
