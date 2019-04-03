library widget.global;

Map<String, bool> commentValues = {
  'Helpful': false,
  'Considerate': false,
  'Responsible': false,
  'Enthusiastic': false,
  'Punctual': false,
  'Skillful': false,
};

void init() {
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
