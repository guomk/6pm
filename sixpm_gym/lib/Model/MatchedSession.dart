import 'package:cloud_firestore/cloud_firestore.dart';

class MatchedSession {
  String date;
  String startTime;
  String endTime;
  String location;
  String userID1;
  String userID2;
  String comment1;
  String comment2;
  String feedback1;
  String feedback2;
  String focus;
  double numHour;
  int id;
  bool hasCheckIn1;
  bool hasCheckIn2;
  bool completed;
  double rate1;
  double rate2;
  Timestamp startDateTime;
  DocumentReference docRef;

  //Constructor
  MatchedSession(
      this.location,
      this.userID1,
      this.userID2,
      this.focus,
      this.date,
      this.startTime,
      this.endTime,
      this.startDateTime,
      this.numHour,
      this.id) {
    //Initialized variables
    completed = false;
    hasCheckIn1 = false;
    hasCheckIn2 = false;
    rate1 = null;
    rate2 = null;
    comment1 = '';
    comment2 = '';
    feedback1 = '';
    feedback2 = '';
  }

  Map<String, Object> getMap() {
    Map<String, Object> data = <String, Object>{
      'ID': id,
      'location': location,
      'startTime': startTime,
      'endTime': endTime,
      'date': date,
      'startDateTime': startDateTime,
      'focus': focus,
      'userID1': userID1,
      'userID2': userID2,
      'feedback1': feedback1,
      'feedback2': feedback2,
      'comment1': comment2,
      'comment2': comment2,
      'rate1': rate1,
      'rate2': rate2,
      'hasCheckIn1': hasCheckIn1,
      'hasCheckIn2': hasCheckIn2,
      'completed': completed,
      'numHour': numHour,
    };
    return data;
  }
}
