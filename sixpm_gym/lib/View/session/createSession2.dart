import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/radiobutton_sessionfocus.dart';
import '../widgets/radiobutton_genderPreference.dart';
import 'package:sixpm_gym/Controller/UnmatchedSessionController.dart';
import 'package:sixpm_gym/Model/globals_session.dart' as globals;
import 'package:sixpm_gym/Model/globals_UID.dart' as globalUID;

class CreateSession2 extends StatefulWidget {
  final List<Map<String, dynamic>> params;

  const CreateSession2({Key key, this.params}) : super(key: key);
  @override
  CreateSession2State createState() => new CreateSession2State();
}

class CreateSession2State extends State<CreateSession2> {
  String _level = 'Newbie';
  DocumentReference doc;

  void _confirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("New Session Info"),
          content: new Text("Date: " +
              widget.params[3]['date'] +
              "\n" +
              "Time: " +
              widget.params[1]['startTime'] +
              " - " +
              widget.params[2]['endTime'] +
              "\n" +
              "Gym: " +
              widget.params[0]['location'] +
              "\n" +
              "Focus: " +
              globals.focus +
              "\n" +
              "Level of experience: " +
              _level),
          actions: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  new FlatButton(
                    child: new Text("Back"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  new FlatButton(
                    child: new Text("Confirm"),
                    onPressed: () {
                      widget.params.add({'level': _level});
                      widget.params.add({'focus': globals.focus});
                      widget.params.add({'sameGender': globals.sameGender});
                      widget.params.add({'userID': globalUID.uid});
                      UnmatchedSessionController().createUnmatchedSession(widget.params, globalUID.uid);
                      Navigator.popUntil(
                          context, ModalRoute.withName('homepage'));
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(10.0, 50.0, 0.0, 0.0),
            child: Text(
              'Create my own session!',
              style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10.0, 20.0, 20.0, 0.0),
            child: Card(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(0.0, 10.0, 245.0, 0.0),
                    child: Text(
                      'My Focus:',
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SessionfocusRadioButton(),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
          Container(
              padding: EdgeInsets.fromLTRB(15.0, 25.0, 100.0, 0.0),
              child: Stack(
                children: <Widget>[
                  Text(
                    'My level of experience in this focus :',
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(150.0, 20.0, 0.0, 0.0),
                    child: DropdownButton<String>(
                      value: _level,
                      style: TextStyle(
                          inherit: true,
                          fontSize: 20.0,
                          color: Colors.blue,
                          decorationColor: Colors.blue),
                      items: <String>[
                        'Newbie',
                        'Pro',
                      ].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (item) {
                        setState(() {
                          _level = item;
                        });
                      },
                    ),
                  ),
                ],
              )),
          Container(
              child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 50.0, 0.0),
                child: Text(
                  'Do you prefer partner of the same gender?',
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                ),
              ),
              GenderPrefrenceRadioButton(),
            ],
          )),
          Container(
              padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    height: 40.0,
                    width: 100.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      shadowColor: Colors.grey,
                      color: Colors.white,
                      elevation: 7.0,
                      child: InkWell(
                        onTap: () {
                          //Reset globals set in this page only
                          globals.focus = 'HIIT';
                          globals.sameGender = true;
                          Navigator.of(context).pop();
                        },
                        child: Center(
                          child: Text(
                            'GO BACK',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0, width: 150),
                  Container(
                    height: 40.0,
                    width: 100.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      shadowColor: Colors.blueAccent,
                      color: Colors.blue,
                      elevation: 7.0,
                      child: InkWell(
                        onTap: () {
                          _confirmationDialog();
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
                ],
              )),
        ],
      ),
    );
  }
}
