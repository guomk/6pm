import 'package:flutter/material.dart';
import 'package:sixpm_gym/Model/globals_session.dart' as globalComment;

class CommentCheckbox extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CommentCheckboxState();
  }
}

class _CommentCheckboxState extends State<CommentCheckbox> {
  Map<String, bool> commentValues = {
    'Helpful': false,
    'Considerate': false,
    'Responsible': false,
  };
  Map<String, bool> commentValues1 = {
    'Enthusiastic': false,
    'Punctual': false,
    'Skillful': false,
  };

  bool flag = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
      child: new Stack(
        children: <Widget>[
          Column(
            children: commentValues.keys
                .map((key) => Container(
                      height: 45.0,
                      child: CheckboxListTile(
                        value: commentValues[key],
                        onChanged: (value) {
                        setState(() {
                          commentValues[key] = value;
                          globalComment.commentValues[key] = value;
                          });
                        },
                        title: new Text(key),
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: Colors.red,
                      ),
                    ))
                .toList(),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(180.0, 0.0, 0.0, 0.0),
            child: Column(
              children: commentValues1.keys
                  .map((key) => Container(
                        height: 45.0,
                        child: CheckboxListTile(
                          value: commentValues1[key],
                          onChanged: (value) {
                        setState(() {
                          commentValues1[key] = value;
                          globalComment.commentValues[key] = value;
                          });
                        },
                          title: new Text(key),
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: Colors.red,
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}