import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './mySessions.dart';
import '../widgets/init_db.dart';
import '../widgets/clear_db.dart';

class MyProfile extends StatefulWidget {
  final FirebaseUser user;
  MyProfile({Key key, @required this.user}) : super(key: key);
  @override
  _MyProfileState createState() => new _MyProfileState(user);
}

class _MyProfileState extends State<MyProfile> {
  // List<String> items = ['1', '2', '3'];
  final FirebaseUser user;
  _MyProfileState(this.user);

  Future<DocumentSnapshot> getProfileDocument() async {
    DocumentSnapshot document =
        await Firestore.instance //Get current user profile
            .collection('Profile')
            .document(user.uid)
            .get();
    return document;
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
        future: getProfileDocument(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              return Scaffold(
                body: Stack(
                  children: <Widget>[
                    ClipPath(
                      child: Container(
                        height: 300,
                        color: Colors.black.withOpacity(0.7),
                      ),
                      clipper: GetClipper(),
                    ),
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.fromLTRB(35.0, 55.0, 0, 0),
                              child: Material(
                                elevation: 4.0,
                                shape: CircleBorder(),
                                color: Colors.transparent,
                                child: Ink.image(
                                  image: AssetImage('img/avatar1.png'),
                                  fit: BoxFit.cover,
                                  width: 120.0,
                                  height: 120.0,
                                  child: InkWell(
                                    onTap: () {
                                      print('[Avatar] Tapped');
                                    },
                                    child: null,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(30.0, 80.0, 0, 0),
                              child: Container(
                                padding: EdgeInsets.all(7.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          snapshot.data['username'],
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(width: 7.0),
                                        snapshot.data['gender'] == 'male'
                                            ? Image.asset(
                                                'img/male.png',
                                                height: 20.0,
                                                width: 20.0,
                                              )
                                            : Image.asset(
                                                'img/female.png',
                                                height: 20.0,
                                                width: 20.0,
                                              )
                                      ],
                                    ),
                                    SizedBox(height: 9.0),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          'You have exercised ' +
                                              snapshot.data['hourSum']
                                                  .toString() +
                                              ' hours!',
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 13.0,
                                              color: Colors.grey),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Container(
                          padding: EdgeInsets.all(7.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.star),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(
                                    snapshot.data['currentRating']
                                        .toStringAsFixed(2),
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 20.0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          title: Text('Interest'),
                                          content:
                                              Text(snapshot.data['interest']),
                                        ));
                              },
                              child: Card(
                                child: Container(
                                  height: 100.0,
                                  width: 120,
                                  padding: EdgeInsets.all(7.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.favorite_border),
                                      SizedBox(height: 4.0),
                                      Text(
                                        'Interest',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 20.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 35.0,
                            ),
                            InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          title: Text('Strength'),
                                          content:
                                              Text(snapshot.data['strength']),
                                        ));
                              },
                              child: Card(
                                child: Container(
                                  height: 100,
                                  width: 120,
                                  padding: EdgeInsets.all(7.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.accessibility_new),
                                      SizedBox(height: 4.0),
                                      Text(
                                        'Strength',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 20.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed('/mySessions');
                          },
                          child: Card(
                            child: Container(
                              height: 70,
                              width: 280,
                              padding: EdgeInsets.all(7.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.event_busy),
                                  SizedBox(height: 4.0),
                                  Text(
                                    'Unmatched Sessions',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 20.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Container(
                          height: 30.0,
                          width: 200.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Colors.redAccent,
                            color: Colors.red,
                            elevation: 7.0,
                            child: InkWell(
                              onTap: signOut,
                              child: Center(
                                child: Text(
                                  'LOGOUT',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat'),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(children: <Widget>[
                          //NOTE COMMENT THIS ROW WHEN PRESENTING
                          ClearDBWidget(),
                          InitDBWidget(),
                        ])
                      ],
                    )

                    // SizedBox(child: -20.0,)
                  ],
                ),
              );
            }
          } else {
            return new Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  void signOut() async {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
            title: new Text('Logout'),
            content: new Text('Do you want to logout?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                },
                child: new Text('Yes'),
              ),
            ],
          ),
    );
  }
}

class GetClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 1.9);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
