import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../globalUserID.dart' as globalUID;

class CompletedSession extends StatelessWidget {
  CompletedSession(this.document); //constructor receives session document from sessionHistory
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
                new Icon(Icons.person, color: Colors.black, size: 100),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 0.0),
            child: Text(
              'Past session details:',
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
        ],
      ),
    );
  }
}