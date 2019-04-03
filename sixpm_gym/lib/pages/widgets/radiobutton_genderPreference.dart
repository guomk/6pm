import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import '../session/global.dart' as globals;

class GenderPrefrenceRadioButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GenderPrefrenceRadioButtonState();
  }
}

class _GenderPrefrenceRadioButtonState
    extends State<GenderPrefrenceRadioButton> {
  String _picked = "Yes";
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: RadioButtonGroup(
          orientation: GroupedButtonsOrientation.HORIZONTAL,
          margin: const EdgeInsets.only(left: 12.0),
          onSelected: (String selected) => setState(() {
                _picked = selected;
                if (_picked == "Yes") {
                  globals.sameGender = true;
                } else {
                  globals.sameGender = false;
                }
              }),
          labels: <String>[
            "Yes",
            "No",
          ],
          picked: _picked,
          itemBuilder: (Radio rb, Text txt, int i) {
            return Row(
              children: <Widget>[
                rb,
                txt,
              ],
            );
          },
        ));
  }
}
