import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../globalUserID.dart' as globalUID;

class SessionInfo extends StatelessWidget {
  SessionInfo(
      {this.unmatchedDocument}); //constructor receives session document from joinSession
  final DocumentSnapshot unmatchedDocument;

  void _showConfirmationDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Confirmation Screen"),
          content: new Text("Confirm join session?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Back"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Confirm"),
              onPressed: () {
                add();
                Navigator.popUntil(context, ModalRoute.withName('homepage'));
              },
            ),
          ],
        );
      },
    );
  }

  Future<DocumentSnapshot> getPartner(DocumentSnapshot document) async {
    DocumentSnapshot partnerDoc;
    String partnerUID = document['userID'];

    partnerDoc = await Firestore.instance //Get partner profile
        .collection('Profile')
        .document(partnerUID)
        .get();

    return partnerDoc;
  }

  Future add() async {
    var highestID = 0;
    //Get current highest MatchedSession document ID
    await Firestore.instance
        .collection('MatchedSession')
        .getDocuments()
        .then((doc) {
      int sessionCount = doc.documents.length;
      if (sessionCount != 0) {
        for (int i = 0; i < sessionCount; i++) {
          DocumentSnapshot session = doc.documents[i];
          int sessionID = int.parse(session['ID']);
          if (sessionID > highestID) highestID = sessionID;
        }
      }
    });

    //Specify data that goes into new MatchedDocument
    String idNum = (highestID + 1).toString();
    final DocumentReference newMatchedDocument =
        Firestore.instance.document('MatchedSession/session$idNum');
    Map<String, Object> data = <String, Object>{
      'ID': idNum,
      'location': unmatchedDocument['location'],
      'startTime': unmatchedDocument['startTime'],
      'endTime': unmatchedDocument['endTime'],
      'date': unmatchedDocument['date'],
      'startDateTime': unmatchedDocument['startDateTime'],
      'focus': unmatchedDocument['focus'],
      'userID1': unmatchedDocument['userID'],
      'userID2': globalUID.uid,
      'feedback1': "",
      'feedback2': "",
      'comment1': "",
      'comment2': "",
      'rate1': null,
      'rate2': null,
      'hasCheckIn1': false,
      'hasCheckIn2': false,
      'completed': false,
      'numHour' : unmatchedDocument['numHour'],
    };

    //Add new MatchedDocument into DB
    newMatchedDocument.setData(data).whenComplete(() {
      print("MatchedSession/session$idNum added");
    }).catchError((e) => print(e));

    //Set isMatched of unmatchedSession to true
    DocumentReference unmatchedDocRef = Firestore.instance
        .collection('UnmatchedSession')
        .document(unmatchedDocument.documentID);
    unmatchedDocRef.updateData({'isMatched': true});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Session Details'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(70, 50, 0, 0),
            child: Row(
              children: <Widget>[
                new Icon(Icons.person, color: Colors.black, size: 100),
                new Icon(Icons.link, color: Colors.black, size: 80),
                new Icon(Icons.help, color: Colors.black, size: 100),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 0.0),
            child: Text(
              'Waiting for someone to join...',
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Card(
            color: Colors.white,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20),
                  Text(
                    'Date: ' + unmatchedDocument['date'],
                    style: TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.normal),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Time: ' +
                        unmatchedDocument['startTime'] +
                        ' - ' +
                        unmatchedDocument['endTime'],
                    style: TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.normal),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Location: ' + unmatchedDocument['location'],
                    style: TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.normal),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Focus: ' + unmatchedDocument['focus'],
                    style: TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.normal),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Level of experience: ' + unmatchedDocument['level'],
                    style: TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.normal),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Gender: ' + unmatchedDocument['userGender'],
                    style: TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.normal),
                  ),
                  new FutureBuilder(
                      future: getPartner(unmatchedDocument),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data != null) {
                            return Text(
                                    'Partner Rating: ' +
                                    snapshot.data['currentRating'].toStringAsFixed(2),
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.normal));
                          }
                        } else {
                          return new CircularProgressIndicator();
                        }
                      }),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
        height: 40.0,
        child: Material(
          borderRadius: BorderRadius.circular(20.0),
          shadowColor: Colors.blueAccent,
          color: Colors.blue,
          elevation: 7.0,
          child: InkWell(
            onTap: () {
              _showConfirmationDialog(context);
            },
            child: Center(
              child: Text(
                'Join Session',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat'),
              ),
            ),
          ),
        ),
      ),
          SizedBox(height: 10),
          Container(
            height: 40.0,
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              shadowColor: Colors.grey,
              color: Colors.white,
              elevation: 7.0,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Center(
                  child: Text(
                    'Go Back',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
