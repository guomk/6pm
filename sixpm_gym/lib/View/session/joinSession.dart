import 'package:flutter/material.dart';
import 'sessionInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sixpm_gym/Model/globals_UID.dart' as globalUID;

class SessionList extends StatefulWidget {
  @override
  SessionListState createState() => new SessionListState();
}

class SessionListState extends State<SessionList> {
  CollectionReference col = Firestore.instance.collection('UnmatchedSession');
  String _gender = '', _level = '';

  Future _getCurrentGenderLevel() async {
    DocumentReference document =
        Firestore.instance //Get current user gender and level of experience
            .collection('Profile')
            .document(globalUID.uid);
    document.get().then((profile) {
      setState(() {
        _gender = profile['gender'];
        _level = profile['level'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentGenderLevel();
  }

  Widget build(BuildContext context) {
    List<DocumentSnapshot> docs;
    DateTime now = DateTime.now();

    return StreamBuilder<QuerySnapshot>(
      stream: col.where('isMatched', isEqualTo: false).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}'); //error checking
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: new CircularProgressIndicator());
          default:
            docs = snapshot.data.documents; //adds all documents to a list

            //client-side filters
            docs.retainWhere((item) =>
                item['userID'] !=
                globalUID
                    .uid); //removes all documents where userID = current user

            docs.retainWhere((item) => ((item['sameGender'] == false) ||
                ((item['sameGender'] == true) &&
                    (item['userGender'] ==
                        _gender)))); //removes all documents where sameGender = true but userGender != curent gender

            if (_level == 'Newbie')
              docs.retainWhere((item) =>
                  item['level'] ==
                  'Pro'); //removes all documents where level = Newbie if the current user is a Newbie

            docs.retainWhere((item) => now.isBefore(
                DateTime.fromMillisecondsSinceEpoch(item['startDateTime']
                    .millisecondsSinceEpoch))); //removes all documents where start datetime is before now (expired)

            if (docs.length != 0) {
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: docs.length,
                itemBuilder: (_, int index) {
                  final DocumentSnapshot document = docs[index];

                  return Card(
                      elevation: 8.0,
                      margin: new EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 2.0),
                      child: Container(
                        alignment: Alignment.center,
                        height: 75,
                        decoration:
                            BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0)),
                        child: InkWell(
                          child: Container(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.people,
                                  color: Colors.black, size: 60.0),
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                width: 290,
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                        document['date'] +
                                            ', ' +
                                            document['startTime'] +
                                            ' - ' +
                                            document['endTime'],
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    Container(
                                        child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Container(
                                            height: 40.0,
                                            width: 125.0,
                                            color: Colors.transparent,
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        style:
                                                            BorderStyle.solid,
                                                        width: 1.0),
                                                    color: Colors.transparent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0)),
                                                child: Center(
                                                  child: Text(
                                                      document['location'],
                                                      overflow:
                                                          TextOverflow.clip,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ))),
                                        Container(
                                            height: 40.0,
                                            width: 125.0,
                                            color: Colors.transparent,
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        style:
                                                            BorderStyle.solid,
                                                        width: 1.0),
                                                    color: Colors.transparent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0)),
                                                child: Center(
                                                  child: Text(document['focus'],
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ))),
                                      ],
                                    ))
                                  ],
                                ),
                              )
                            ],
                          )),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SessionInfo(
                                        document))); //Sends current session document to sessionInfo page
                          },
                        ),
                      ));
                },
              );
            } else {
              return Container(
                  padding: EdgeInsets.fromLTRB(35, 20, 35, 0),
                  alignment: Alignment.center,
                  child: Center(
                      child: Text(
                          'There are no sessions to display. Why don\'t you create one?',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold))));
            }
        }
      },
    );
  }
}

class JoinSessionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Join Session'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(60.0, 10.0, 0.0, 0.0),
              child: Text('Join A Session!',
                  style:
                      TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 10.0),
            new Expanded(
              child: SessionList(), //Load sessions from DB
            )
          ],
        ));
  }
}
