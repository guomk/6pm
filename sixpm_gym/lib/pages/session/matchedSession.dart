import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../globalUserID.dart' as globalUID;
import '../session/checkin.dart';

class MatchedSession extends StatelessWidget {
  MatchedSession(
      {this.document}); //constructor receives session document from sessionMain
  final DocumentSnapshot document;

  Future<DocumentSnapshot> getPartner(DocumentSnapshot document) async {
    DocumentSnapshot partnerDoc;
    String partnerUID;
    if (globalUID.uid == document['userID1']) //Partner is UserID2
      partnerUID = document['userID2'];
    else //Partner is UserID1
      partnerUID = document['userID1'];

    partnerDoc = await Firestore.instance //Get partner profile
        .collection('Profile')
        .document(partnerUID)
        .get();

    return partnerDoc;
  }

  Widget _checkInButton(context, allowCheckIn) {
    if (!allowCheckIn) {
      return Container(
        height: 40.0,
        child: Material(
          borderRadius: BorderRadius.circular(20.0),
          shadowColor: Colors.blueAccent,
          color: Colors.grey,
          elevation: 7.0,
          child: InkWell(
            child: Center(
              child: Text(
                'Check In',
                style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat'),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container(
        height: 40.0,
        child: Material(
          borderRadius: BorderRadius.circular(20.0),
          shadowColor: Colors.blueAccent,
          color: Colors.blue,
          elevation: 7.0,
          child: InkWell(
            onTap: () {
              print('[Check In] Pressed');
              if (document != null) {
                bool partnerIsID1;
                if (globalUID.uid == document['userID1']) //Partner is UserID2
                  partnerIsID1 = false;
                else //Partner is UserID1
                  partnerIsID1 = true;

                if (partnerIsID1)
                  document.reference
                      .updateData({'hasCheckIn2': true})
                      .whenComplete(() {})
                      .catchError((e) => print(e));
                else
                  document.reference
                      .updateData({'hasCheckIn1': true})
                      .whenComplete(() {})
                      .catchError((e) => print(e));

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SessionCheckIn(document: document)));
              }
            },
            child: Center(
              child: Text(
                'Check In',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat'),
              ),
            ),
          ),
        ),
      );
    }
  }

  void _confirmCancelDialog(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
            title: new Text('Cancel Session'),
            content: new Text('Are you sure you want to cancel this session?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () {
                  DocumentReference docRef = Firestore.instance
                      .collection('MatchedSession')
                      .document(document.documentID);
                  Firestore.instance
                      .runTransaction((Transaction myTransaction) async {
                    await myTransaction.delete(docRef);
                    Navigator.popUntil(
                        context, ModalRoute.withName('homepage'));
                  });
                },
                child: new Text('Yes'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime checkin = DateTime.now().add(new Duration(minutes: 15));
    final bool allowCheckIn = (checkin.isAfter(
        document['startDateTime'])); //Only can check in after start time
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
                new Icon(Icons.person, color: Colors.black, size: 100),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 0.0),
            child: Text(
              'Your upcoming session details:',
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
                  new FutureBuilder(
                      future: getPartner(document),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data != null) {
                            return Text(
                                'Partner: ' +
                                    snapshot.data['firstName'] +
                                    ' ' +
                                    snapshot.data['lastName'],
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.normal));
                          }
                        } else {
                          return new CircularProgressIndicator();
                        }
                      }),
                  SizedBox(height: 10),
                  Text(
                    'Date: ' + document['date'],
                    style: TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.normal),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Time: ' +
                        document['startTime'] +
                        ' - ' +
                        document['endTime'],
                    style: TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.normal),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Location: ' + document['location'],
                    style: TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.normal),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Focus: ' + document['focus'],
                    style: TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.normal),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          _checkInButton(context, allowCheckIn),
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
                  print('[Cancel Session] Pressed');
                  _confirmCancelDialog(context);
                },
                child: Center(
                  child: Text(
                    'CANCEL SESSION',
                    style: TextStyle(
                        color: Colors.red,
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
