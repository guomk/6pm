import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import '../widgets/checkbox_comment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../globalUserID.dart' as globalUID;
import '../widgets/global_comment.dart' as globalComment;

class RateSession extends StatefulWidget {
  final DocumentSnapshot document;
  RateSession({this.document});
  @override
  _RateSessionState createState() => _RateSessionState(document);
}

class _RateSessionState extends State<RateSession> {
  _RateSessionState(DocumentSnapshot document) {
    this.document = document;
  }
  DocumentSnapshot document, currentUserDoc, partnerDoc;
  final textController = TextEditingController();
  
  getCurrentUser() {
    Firestore.instance //Get current user profile
        .collection('Profile')
        .document(globalUID.uid)
        .get()
        .then((doc) => {currentUserDoc = doc});
  }

  getPartner(DocumentSnapshot matchedDocument) {
    String partnerUID;
    if (globalUID.uid == matchedDocument['userID1']) //Partner is UserID2
      partnerUID = matchedDocument['userID2'];
    else //Partner is UserID1
      partnerUID = matchedDocument['userID1'];

    Firestore.instance //Get partner profile
        .collection('Profile')
        .document(partnerUID)
        .get()
        .then((doc) => {partnerDoc = doc});
  }

  double rating = 0;
  int starCount = 5;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getPartner(document);
    globalComment.init();
  }

  void dispose() {
    // Clean up the controller when the Widget is disposed
    textController.dispose();
    super.dispose();
  }

  void _errorDialog(context, reason) {
    if (reason == 1) {    //No rating selected
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Error!"),
            content: new Text("Please select a rating for your partner!"),
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
    } else {      //No feedback provided
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Error!"),
            content: new Text("Please provide some feedback!"),
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
  }

  Future<bool> _onWillPop() {   //Block user from backing out of feedback page
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Error!"),
          content: new Text("You cannot skip this feedback page!"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Okay"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    bool partnerIsID1;
    if (globalUID.uid == document['userID1']) //Partner is UserID2
      partnerIsID1 = false;
    else //Partner is UserID1
      partnerIsID1 = true;

    return new WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
          resizeToAvoidBottomPadding: false,
          body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
              Widget>[
            Container(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(children: [
                        Text('Feedback',
                            style: TextStyle(
                                fontSize: 35.0, fontWeight: FontWeight.bold)),
                        Divider(color: Colors.black)
                      ]),
                    )
                  ],
                )),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
              child: Text(
                'Rate your partner:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              child: new StarRating(
                size: 60.0,
                color: Colors.orange,
                borderColor: Colors.grey,
                rating: rating,
                starCount: starCount,
                onRatingChanged: (rating) => setState(() {
                      this.rating = rating;
                    }),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Text(
                'Comment on your partner:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            CommentCheckbox(),
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Text(
                'Remark on session:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Center(
                child: Container(
                    padding: EdgeInsets.only(left: 5),
                    height: 150,
                    width: 350,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 1.0),
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: ' Please provide some feedback:'),
                      controller: textController,
                    ))),
            SizedBox(height: 15),
            Container(
                padding: EdgeInsets.fromLTRB(120.0, 10.0, 30.0, 20.0),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        height: 50,
                        width: 170,
                        child: Material(
                          borderRadius: BorderRadius.circular(10.0),
                          shadowColor: Colors.blueAccent,
                          color: Colors.blue,
                          elevation: 7.0,
                          child: InkWell(
                            onTap: () {
                              if (rating == 0) {
                                _errorDialog(context, 1);
                              } else if (textController.text == '') {
                                _errorDialog(context, 2);
                              } else {
                                //Update matchedDocument rate, feedback, comments
                                if (partnerIsID1) {
                                  document.reference
                                      .updateData({
                                        'rate2': rating,
                                        'feedback2': textController.text,
                                        'comment2' : globalComment.getComments()
                                      })
                                      .whenComplete(() {})
                                      .catchError((e) => print(e));
                                } else {
                                  document.reference
                                      .updateData({
                                        'rate1': rating,
                                        'feedback1': textController.text,
                                        'comment1' : globalComment.getComments()
                                      })
                                      .whenComplete(() {})
                                      .catchError((e) => print(e));
                                }
                                //Flag session as completed
                                document.reference
                                    .updateData({'completed': true})
                                    .whenComplete(() {})
                                    .catchError((e) => print(e));
                                //Update current user document hourSum and numOfSession and average rating
                                currentUserDoc.reference
                                    .updateData({
                                      'numOfSession':
                                          (currentUserDoc['numOfSession'] + 1),
                                      'hourSum': (currentUserDoc['hourSum'] +
                                          document['numHour'])
                                    })
                                    .whenComplete(() {})
                                    .catchError((e) => print(e));
                                //Update partner user document hourSum and numOfSession and average rating
                                partnerDoc.reference
                                    .updateData({
                                      'currentRating': (((partnerDoc[
                                                      'currentRating'] *
                                                  (partnerDoc['numOfSession'] +
                                                      1)) +
                                              rating) /
                                          (partnerDoc['numOfSession'] + 2)),
                                      'hourSum': (partnerDoc['hourSum'] +
                                          document['numHour']),
                                      'numOfSession':
                                          (partnerDoc['numOfSession'] + 1)
                                    })
                                    .whenComplete(() {})
                                    .catchError((e) => print(e));
                                Navigator.popUntil(
                                    context, ModalRoute.withName('homepage'));
                              }
                            },
                            child: Center(
                              child: Text(
                                'OKAY',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]))
          ])),
    );
  }
}
