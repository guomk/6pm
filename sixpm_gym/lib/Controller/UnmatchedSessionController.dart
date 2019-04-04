import 'package:sixpm_gym/Model/UnmatchedSession.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sixpm_gym/Model/globals_session.dart' as globals;

class UnmatchedSessionController {
  UnmatchedSession session;
  DocumentReference doc;

  void createUnmatchedSession(
      List<Map<String, dynamic>> params, String uid) async {
    var highestID = 0;
    await Firestore.instance //Get highest session document ID
        .collection('UnmatchedSession')
        .getDocuments()
        .then((doc) {
      int sessionCount = doc.documents.length;
      if (sessionCount != 0) {
        for (int i = 0; i < sessionCount; i++) {
          DocumentSnapshot session = doc.documents[i];
          if (session['ID'] > highestID) highestID = session['ID'];
        }
      }
    });
    highestID++;  //increment highest ID to set new document ID

    //Get current user gender
    String _gender = '';
    await Firestore.instance 
        .collection('Profile')
        .document(uid)
        .get()
        .then((profile) {
      _gender = profile['gender'];
    });

    //Create new unmatched session
    session = new UnmatchedSession(
        params[0]['location'],
        params[9]['userID'],
        params[7]['focus'],
        params[3]['date'],
        params[1]['startTime'],
        params[2]['endTime'],
        params[4]['startDateTimeISO'],
        _gender,
        params[6]['level'],
        params[5]['numHour'],
        params[8]['sameGender'],
        highestID);

    //add session document and enter fields
    doc = Firestore.instance.document('UnmatchedSession/session$highestID');
    doc.setData(session.getMap()).whenComplete(() {
      session.docRef = doc;
      globals.unmatchedList.add(session);
      print("UnmatchedSession/session$highestID added");
    }).catchError((e) => print(e));
  }

  UnmatchedSession getSessionFromDoc(DocumentSnapshot doc){
     for(UnmatchedSession ums in globals.unmatchedList){
       if (ums.docRef == doc.reference)
       return ums;
     }
     return null;
  }
}
