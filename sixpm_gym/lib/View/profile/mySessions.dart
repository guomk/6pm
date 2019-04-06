import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sixpm_gym/Model/globals_UID.dart' as globalUID;

class MySessionList extends StatefulWidget {
  @override
  _MySessionListState createState() => new _MySessionListState();
}

class _MySessionListState extends State<MySessionList> {
  CollectionReference col = Firestore.instance.collection('UnmatchedSession');

  Widget build(BuildContext context) {
    List<DocumentSnapshot> docs;

    return StreamBuilder<QuerySnapshot>(
      stream: col
          .where('userID', isEqualTo: globalUID.uid)
          .snapshots(), //gets all unmatched sessions by current user
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}'); //error checking
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Center(child: CircularProgressIndicator());
          default:
            docs = snapshot.data.documents; //adds all documents to a list

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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.people, color: Colors.black, size: 60.0),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                            width: 290,
                            alignment: Alignment.center,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                    style: BorderStyle.solid,
                                                    width: 1.0),
                                                color: Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                            child: Center(
                                              child: Text(document['location'],
                                                  overflow: TextOverflow.clip,
                                                  textAlign: TextAlign.center,
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
                                                    style: BorderStyle.solid,
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
                      ),
                    ),
                  );
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

class MySessions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('My Unmatched Sessions'),
        ),
        body: Column(
          children: <Widget>[
            SizedBox(height: 20),
            new Expanded(
              child: MySessionList(), //Load sessions from DB
            )
          ],
        ));
  }
}
