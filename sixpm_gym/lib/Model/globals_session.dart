library session.global;
import 'package:sixpm_gym/Model/MatchedSession.dart';
import 'package:sixpm_gym/Model/UnmatchedSession.dart';
String date = '';
String dateISO = '';
String focus = 'HIIT';
bool sameGender = true;
List<UnmatchedSession> unmatchedList = new List();
List<MatchedSession> matchedList = new List();

Map<String, bool> commentValues = {
  'Helpful': false,
  'Considerate': false,
  'Responsible': false,
  'Enthusiastic': false,
  'Punctual': false,
  'Skillful': false,
};

void init() {
  date = '';
  dateISO = '';
  focus = 'HIIT';
  sameGender = true;
}

void initComments(){
  commentValues['Helpful'] = false;
  commentValues['Considerate'] = false;
  commentValues['Responsible'] = false;
  commentValues['Enthusiastic'] = false;
  commentValues['Punctual'] = false;
  commentValues['Skillful'] = false;
}

String getComments() {
  String allComments = '';

  if (commentValues['Helpful'] == true) allComments = allComments + 'Helpful, ';
  if (commentValues['Considerate'] == true)
    allComments = allComments + 'Considerate, ';
  if (commentValues['Responsible'] == true)
    allComments = allComments + 'Responsible, ';
  if (commentValues['Enthusiastic'] == true)
    allComments = allComments + 'Enthusiastic, ';
  if (commentValues['Punctual'] == true)
    allComments = allComments + 'Punctual, ';
  if (commentValues['Skillful'] == true)
    allComments = allComments + 'Skillful, ';

  if (allComments != '') allComments = allComments.substring(0, allComments.length - 2);  //If not null, remove last comma and space

  return allComments;
}
