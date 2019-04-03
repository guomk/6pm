import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import '../welcome/global.dart' as global;

class DatePickerWidget extends StatefulWidget {
  DatePickerWidget({Key key}) : super(key: key);

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  String _datetime = '';
  int _year = 2018;
  int _month = 11;
  int _date = 11;

  String _lang = 'en';
  String _format = 'yyyy-mmmm-dd';
  bool _showTitleActions = false;

  TextEditingController _langCtrl = TextEditingController();
  TextEditingController _formatCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _langCtrl.text = 'en';
    _formatCtrl.text = 'yyyy-mmmm-dd';

    DateTime now = DateTime.now();
    _year = now.year;
    _month = now.month;
    _date = now.day;
  }

  /// Display date picker.
  void _showDatePicker() {
    final bool showTitleActions = false;
    DatePicker.showDatePicker(
      context,
      showTitleActions: _showTitleActions,
      minYear: 1900,
      maxYear: DateTime.now().year,
      initialYear: _year,
      initialMonth: _month,
      initialDate: _date,
      confirm: Text(
        'Confirm',
        style: TextStyle(color: Colors.red),
      ),
      cancel: Text(
        'Cancel',
        style: TextStyle(color: Colors.cyan),
      ),
      locale: _lang,
      dateFormat: _format,
      onChanged: (year, month, date) {
        if (!showTitleActions) {
          _changeDatetime(year, month, date);
        }
      },
      onConfirm: (year, month, date) {
        _changeDatetime(year, month, date);
      },
    );
  }

  void _changeDatetime(int year, int month, int date) {
    String _y, _m, _d;
    _y = year.toString();
    if (month < 10)
      _m = '0' + month.toString();
    else
      _m = month.toString();
    if (date < 10)
      _d = '0' + date.toString();
    else
      _d = date.toString();
    setState(() {
      _year = year;
      _month = month;
      _date = date;
      _datetime = _y + '-' + _m + '-' + _d;
    });
    global.dob = _datetime;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Birthday:',
                style: TextStyle(fontSize: 20.0),
              ),
              Container(
                padding: EdgeInsets.only(left: 12.0),
                child: Text(
                  '$_datetime',
                  style: Theme.of(context).textTheme.title,
                ),
              ),
            ],
          ),
        ),
        Container(
          child: IconButton(
            onPressed: _showDatePicker,
            icon: Icon(Icons.today),
          ),
        ),
      ],
    );
  }
}
