import 'package:sixpm_gym/Model/Profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileController {
  Profile profile;
  DocumentReference doc;

  void createProfile(
      String firstName,
      String lastName,
      String username,
      String email,
      String gender,
      String dob,
      String strength,
      String interest,
      String level,
      String uid) async {
    //Create new Profile
    profile = new Profile(firstName, lastName, username, email, gender, dob,
        strength, interest, level);

    //add session document and enter fields
    Firestore.instance
        .collection('Profile')
        .document(uid)
        .setData(profile.getMap())
        .catchError((e) {
      print(e);
    });
  }

  Future<DocumentSnapshot> getCurrentUserDoc(uid) {
    Future<DocumentSnapshot> userDoc =
        Firestore.instance //Get current user profile
            .collection('Profile')
            .document(uid)
            .get();
    return userDoc;
  }

  void completeSessionUpdate(DocumentSnapshot currentDoc, numHour) {
    currentDoc.reference
        .updateData({
          'numOfSession': (currentDoc['numOfSession'] + 1),
          'hourSum': (currentDoc['hourSum'] + numHour)
        })
        .whenComplete(() {})
        .catchError((e) => print(e));
  }

  void updatePartnerDoc(DocumentSnapshot partnerDoc, rating, numHour) {
    partnerDoc.reference
        .updateData({
          'currentRating': (((partnerDoc['currentRating'] *
                      (partnerDoc['numOfSession'] + 1)) +
                  rating) /
              (partnerDoc['numOfSession'] + 2)),
          'hourSum': (partnerDoc['hourSum'] + numHour),
          'numOfSession': (partnerDoc['numOfSession'] + 1)
        })
        .whenComplete(() {})
        .catchError((e) => print(e));
  }
}
