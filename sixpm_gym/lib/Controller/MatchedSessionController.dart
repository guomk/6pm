import 'package:sixpm_gym/Model/MatchedSession.dart';
import 'package:sixpm_gym/Controller/ProfileController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sixpm_gym/Model/globals_session.dart' as globals;

class MatchedSessionController {
  MatchedSession newMatchedSession;
  DocumentReference doc;

  void createMatchedSession(
      DocumentSnapshot unmatchedDocument, String uid2) async {
    var highestID = 0;
    await Firestore.instance //Get highest session document ID
        .collection('MatchedSession')
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
    highestID++; //increment highest ID to set new document ID

    //Create new unmatched session
    newMatchedSession = new MatchedSession(
        unmatchedDocument['location'],
        unmatchedDocument['userID'],
        uid2,
        unmatchedDocument['focus'],
        unmatchedDocument['date'],
        unmatchedDocument['startTime'],
        unmatchedDocument['endTime'],
        unmatchedDocument['startDateTime'],
        unmatchedDocument['numHour'],
        highestID);

    //add session document and enter fields
    doc = Firestore.instance.document('MatchedSession/session$highestID');
    doc.setData(newMatchedSession.getMap()).whenComplete(() {
      newMatchedSession.docRef = doc;
      globals.matchedList.add(newMatchedSession);
      print("MatchedSession/session$highestID added");
    }).catchError((e) => print(e));

    //Set isMatched of unmatchedSession to true
    unmatchedDocument.reference.updateData({'isMatched': true});
  }

  void deleteMatchedSession(MatchedSession ms) {
    ms.docRef.delete();
    ms = null;
  }

  void checkIn1(bool hasCheckIn, MatchedSession ms) {
    if (hasCheckIn) {
      ms.hasCheckIn1 = true;
      ms.docRef
          .updateData({'hasCheckIn1': true})
          .whenComplete(() {})
          .catchError((e) => print(e));
    } else {
      ms.hasCheckIn1 = false;
      ms.docRef
          .updateData({'hasCheckIn1': false})
          .whenComplete(() {})
          .catchError((e) => print(e));
    }
  }

  void checkIn2(bool hasCheckIn, MatchedSession ms) {
    if (hasCheckIn) {
      ms.hasCheckIn2 = true;
      ms.docRef
          .updateData({'hasCheckIn2': true})
          .whenComplete(() {})
          .catchError((e) => print(e));
    } else {
      ms.hasCheckIn2 = false;
      ms.docRef
          .updateData({'hasCheckIn2': false})
          .whenComplete(() {})
          .catchError((e) => print(e));
    }
  }

  void completeSession1(MatchedSession ms, double rating, String feedback,
      String comment, DocumentSnapshot partnerDoc, double numHour) {
    ms.docRef
        .updateData({
          'rate1': rating,
          'feedback1': feedback,
          'comment1': comment,
          'completed': true,
        })
        .whenComplete(() {})
        .catchError((e) => print(e));

    ProfileController().updatePartnerDoc(partnerDoc, rating, numHour);
  }

  void completeSession2(MatchedSession ms, double rating, String feedback,
      String comment, DocumentSnapshot partnerDoc, double numHour) {
    ms.rate2 = rating;
    ms.feedback2 = feedback;
    ms.comment2 = comment;
    ms.docRef
        .updateData({
          'rate2': rating,
          'feedback2': feedback,
          'comment2': comment,
          'completed': true,
        })
        .whenComplete(() {})
        .catchError((e) => print(e));

    ProfileController().updatePartnerDoc(partnerDoc, rating, numHour);
  }

  MatchedSession getSessionFromDoc(DocumentSnapshot doc) {
    for (MatchedSession ms in globals.matchedList) {
      if (ms.docRef == doc.reference) return ms;
    }
    return null;
  }

  Future<DocumentSnapshot> getPartnerDoc(
      DocumentSnapshot matchedSessionDoc, uid) async {
    DocumentSnapshot partnerDoc;
    String partnerUID;
    if (uid == matchedSessionDoc['userID1']) //Partner is UserID2
      partnerUID = matchedSessionDoc['userID2'];
    else //Partner is UserID1
      partnerUID = matchedSessionDoc['userID1'];

    partnerDoc = await Firestore.instance //Get partner profile
        .collection('Profile')
        .document(partnerUID)
        .get();

    return partnerDoc;
  }
}
