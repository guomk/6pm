//CLEARS MATCHEDSESSION, UNMATCHEDSESSION, PROFILE
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClearDBWidget extends StatelessWidget {
  final CollectionReference profileCollection =
      Firestore.instance.collection('Profile');
  final CollectionReference unmatchedCollection =
      Firestore.instance.collection('UnmatchedSession');
  final CollectionReference matchedCollection =
      Firestore.instance.collection('MatchedSession');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(50, 20, 0, 0),
      height: 50,
      width: 100,
      child: Material(
        borderRadius: BorderRadius.circular(10.0),
        shadowColor: Colors.blueAccent,
        color: Colors.blue,
        elevation: 7.0,
        child: InkWell(
          onTap: () {
            //Delete everything in Profile, Unmatched Session, Matched Session
            profileCollection.getDocuments().then((snapshot) {
              for (DocumentSnapshot ds in snapshot.documents) {
                ds.reference.delete();
              }
            });

            unmatchedCollection.getDocuments().then((snapshot) {
              for (DocumentSnapshot ds in snapshot.documents) {
                ds.reference.delete();
              }
            });

            matchedCollection.getDocuments().then((snapshot) {
              for (DocumentSnapshot ds in snapshot.documents) {
                ds.reference.delete();
              }
            });
          },
          child: Center(
              child: Text(
            'clearDB',
            style: TextStyle(
                color: Colors.white, fontSize: 10, fontFamily: 'Montserrat'),
          )),
        ),
      ),
    );
  }
}
