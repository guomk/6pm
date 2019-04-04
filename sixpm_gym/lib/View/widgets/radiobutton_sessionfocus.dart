import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:sixpm_gym/Model/globals_session.dart' as globals;

class SessionfocusRadioButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SessionfocusRadioButtonState();
  }
}

class _SessionfocusRadioButtonState extends State<SessionfocusRadioButton> {
  String _picked = "HIIT";
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Column(children: [
            RadioButtonGroup(
              orientation: GroupedButtonsOrientation.VERTICAL,
              padding: EdgeInsets.fromLTRB(0.0, 10.0, 120, 0.0),
              onSelected: (String selected) => setState(() {
                    _picked = selected;
                    globals.focus = _picked;
                  }),
              labels: <String>[
                "HIIT",
                "Yoga",
                "Aerobics",
              ],
              picked: _picked,
              itemBuilder: (Radio rb, Text txt, int i) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    rb,
                    txt,
                  ],
                );
              },
            ),
          ]),
          new Column(children: [
            RadioButtonGroup(
              orientation: GroupedButtonsOrientation.VERTICAL,
              onSelected: (String selected) => setState(() {
                    _picked = selected;
                    globals.focus = _picked;
                  }),
              labels: <String>[
                "Burpees",
                "Boxing",
                "Strength",
              ],
              picked: _picked,
              itemBuilder: (Radio rb, Text txt, int i) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    rb,
                    txt,
                  ],
                );
              },
            ),
          ]),
        ],
      ),
    );
  }
}
