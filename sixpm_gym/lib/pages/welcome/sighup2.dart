import 'package:flutter/material.dart';
import '../widgets/date_picker.dart';
import '../home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './global.dart' as global;

class SignupPage2 extends StatefulWidget {
  const SignupPage2(
      {Key key,
      @required this.username,
      @required this.email,
      @required this.password,
      @required this.user})
      : super(key: key);
  final FirebaseUser user;
  final String username, email, password;
  @override
  _SignupPageState2 createState() =>
      _SignupPageState2(user, username, email, password);
}

class _SignupPageState2 extends State<SignupPage2> {
  _SignupPageState2(this.user, this.username, this.email, this.password);
  final FirebaseUser user;
  final String username, email, password;
  String _genderValue = 'male';
  String _levelValue = 'Newbie';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Firestore db = Firestore.instance;
  TextEditingController interestController = new TextEditingController();
  TextEditingController strengthController = new TextEditingController();
  TextEditingController firstnameController = new TextEditingController();
  TextEditingController lastnameController = new TextEditingController();

  void _birthdayError(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Error!"),
          content: new Text("Please enter birthday!"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Okay"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15.0, 40.0, 0.0, 0.0),
                    child: Text(
                      'Almost there',
                      style: TextStyle(
                          fontSize: 40.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(250.0, 40.0, 0.0, 0.0),
                    child: Text(
                      '!',
                      style: TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xfffe8a71)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: Card(
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
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
                              child: null,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Gender:  ',
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                            new DropdownButton<String>(
                              value: _genderValue,
                              style: TextStyle(
                                  inherit: true,
                                  fontSize: 20.0,
                                  color: Colors.blue,
                                  decorationColor: Colors.blue),
                              items: <String>['male', 'female']
                                  .map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value),
                                );
                              }).toList(),
                              onChanged: (item) {
                                setState(() {
                                  _genderValue = item;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: DatePickerWidget(),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Level of Experience:  ',
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                            new DropdownButton<String>(
                              value: _levelValue,
                              style: TextStyle(
                                  inherit: true,
                                  fontSize: 20.0,
                                  color: Colors.blue,
                                  decorationColor: Colors.blue),
                              items:
                                  <String>['Pro', 'Newbie'].map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value),
                                );
                              }).toList(),
                              onChanged: (item) {
                                setState(() {
                                  _levelValue = item;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            width: 160,
                            child: TextFormField(
                              validator: (input) {
                                if (input.isEmpty) {
                                  return 'Please input your First Name';
                                }
                              },
                              controller: firstnameController,
                              autofocus: true,
                              decoration:
                                  InputDecoration(hintText: 'First Name'),
                            ),
                          ),
                          Container(
                            width: 160,
                            child: TextFormField(
                              validator: (input) {
                                if (input.isEmpty) {
                                  return 'Please input your Last Name';
                                }
                              },
                              controller: lastnameController,
                              autofocus: true,
                              decoration:
                                  InputDecoration(hintText: 'Last Name'),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 360,
                        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                        child: TextFormField(
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Please Input your interest';
                            }
                          },
                          controller: interestController,
                          decoration:
                              InputDecoration(hintText: 'Your Interest'),
                        ),
                      ),
                      Container(
                        width: 360,
                        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 30.0),
                        child: TextFormField(
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Please Input your strength';
                            }
                          },
                          controller: strengthController,
                          decoration:
                              InputDecoration(hintText: 'Your Strength'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Center(
              child: Container(
                height: 40.0,
                width: 390.0,
                child: Material(
                  borderRadius: BorderRadius.circular(20.0),
                  shadowColor: Colors.blueAccent,
                  color: Colors.blue,
                  elevation: 7.0,
                  child: InkWell(
                    onTap: () {
                      if (global.dob == '')
                        _birthdayError(context);
                      else
                        createProfile();
                    },
                    child: Center(
                      child: Text(
                        'FINISH',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void createProfile() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      try {
        var dataMap = new Map<String, dynamic>();
        dataMap['gender'] = _genderValue.toLowerCase();
        dataMap['level'] = _levelValue;
        dataMap['username'] = username;
        dataMap['email'] = email;
        dataMap['currentRating'] = 5;
        dataMap['numOfSession'] = 0;
        dataMap['hourSum'] = 0;
        dataMap['interest'] = interestController.text;
        dataMap['strength'] = strengthController.text;
        dataMap['firstName'] = firstnameController.text;
        dataMap['lastName'] = lastnameController.text;
        dataMap['DOB'] = global.dob;

        Firestore.instance
            .collection('Profile')
            .document(user.uid)
            .setData(dataMap)
            .catchError((e) {
          print(e);
        });
        Navigator.popUntil(context, ModalRoute.withName('/'));
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(user: user),
                settings: RouteSettings(name: "homepage")));
      } catch (e) {
        print("{ERROR}");
        print(e.message);
      }
    }
  }
}
