import 'package:cloud_firestore/cloud_firestore.dart';

class UnmatchedSession{
  String date;
  String startTime;
  String endTime;
  String location;
  String userID;
  String userGender;
  String level;
  String focus;
  double numHour;
  int id;
  bool isMatched;
  bool sameGender;
  DateTime startDateTime;
  DocumentReference docRef;

  //Constructor
  UnmatchedSession(
    this.location,
    this.userID,
    this.focus,
    this.date,
    this.startTime,
    this.endTime,
    this.startDateTime,
    this.userGender,
    this.level,
    this.numHour,
    this.sameGender,
    this.id
  ){
    //Initialized variables
    isMatched = false;
  }
  
  void onMatched(){
    isMatched = true;
  }

  Map<String, Object> getMap(){
    Map<String, Object> data = <String, Object>{
      'ID': id,
      'location': location,
      'startTime': startTime,
      'endTime': endTime,
      'date': date,
      'startDateTime':startDateTime,
      'numHour': numHour,
      'level': level,
      'focus': focus,
      'sameGender': sameGender,
      'userID': userID,
      'userGender': userGender,
      'isMatched': isMatched,
    };
    return data;
  }
}