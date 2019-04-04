import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'rateSession.dart';
import 'package:sixpm_gym/Controller/MatchedSessionController.dart';
import 'package:sixpm_gym/Model/MatchedSession.dart';
import 'dart:math';
import 'package:sixpm_gym/Model/globals_UID.dart' as globalUID;

class SessionCheckIn extends StatefulWidget {
  final DocumentSnapshot document;
  SessionCheckIn({this.document});
  @override
  SessionCheckInState createState() => new SessionCheckInState(document);
}

class SessionCheckInState extends State<SessionCheckIn>
    with SingleTickerProviderStateMixin {
  DocumentSnapshot document;
  AnimationController animationController;
  MatchedSession matchedSession;
  bool _sessionStarted = false;
  SessionCheckInState(DocumentSnapshot document) {
    this.document = document;
    matchedSession = MatchedSessionController().getSessionFromDoc(document);
  }

  String get timerString {
    Duration duration =
        animationController.duration * animationController.value;
    return '${duration.inHours}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  Future<bool> _onWillPop() {
    bool partnerIsID1;
    if (globalUID.uid == document['userID1']) //Partner is UserID2
      partnerIsID1 = false;
    else //Partner is UserID1
      partnerIsID1 = true;

    if (!_sessionStarted) {
      //Session has not started, user still can cancel check-in
      return showDialog(
            context: context,
            builder: (context) => new AlertDialog(
                  title: new Text('Cancel check in'),
                  content: new Text(
                      'Are you sure you want to cancel your check in?'),
                  actions: <Widget>[
                    new FlatButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: new Text('No'),
                    ),
                    new FlatButton(
                      onPressed: () {
                        if (partnerIsID1)
                          MatchedSessionController().checkIn2(false, matchedSession);
                        else
                          MatchedSessionController().checkIn1(false, matchedSession);
                      },
                      child: new Text('Yes'),
                    ),
                  ],
                ),
          ) ??
          false;
    } else {
      //Session already started, cannot cancel
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Error!"),
            content: new Text(
                "You cannot cancel a check in after the session has started!\n\nPlease finish the session."),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Okay"),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    int hours = (document['numHour']).toInt();
    if (document['numHour'] == hours)
      animationController =
          AnimationController(vsync: this, duration: Duration(hours: hours));
    else
      animationController = AnimationController(
          vsync: this, duration: Duration(hours: hours, minutes: 30));
  }

  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Widget _startFinishButton(context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('MatchedSession')
            .document(document.documentID)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              DocumentSnapshot sessionDoc = snapshot.data;
              if (!_sessionStarted) {
                if (sessionDoc['hasCheckIn1'] == true &&
                    sessionDoc['hasCheckIn2'] == true) {
                  //Both users have checked in but session has not started
                  return Container(
                    height: 40.0,
                    width: 200,
                    child: Material(
                      borderRadius: BorderRadius.circular(0.0),
                      shadowColor: Colors.grey,
                      color: Colors.white,
                      elevation: 7.0,
                      child: InkWell(
                        onTap: () {
                          if (!animationController.isAnimating)
                            animationController.reverse(
                                from: animationController.value == 0.0
                                    ? 1.0
                                    : animationController.value);
                          setState(() {
                            _sessionStarted = true;
                          });
                        },
                        child: Center(
                          child: Text(
                            'START SESSION',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat'),
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  //Partner has not checked in, unable to start session
                  return Container(
                    height: 40.0,
                    width: 200,
                    child: Material(
                      borderRadius: BorderRadius.circular(0.0),
                      shadowColor: Colors.grey,
                      color: Colors.grey,
                      elevation: 7.0,
                      child: InkWell(
                        child: Center(
                          child: Text(
                            'START SESSION',
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat'),
                          ),
                        ),
                      ),
                    ),
                  );
                }
              } else {
                //Session started
                return Container(
                  height: 40.0,
                  width: 200,
                  child: Material(
                    borderRadius: BorderRadius.circular(0.0),
                    shadowColor: Colors.grey,
                    color: Colors.white,
                    elevation: 7.0,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    RateSession(document, matchedSession)));
                      },
                      child: Center(
                        child: Text(
                          'FINISH SESSION',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat'),
                        ),
                      ),
                    ),
                  ),
                );
              }
            }
          } else {
            return new Text("Loading");
          }
        });
  }

  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(5.0, 50.0, 5.0, 0.0),
                child: new StreamBuilder(
                    stream: Firestore.instance
                        .collection('MatchedSession')
                        .document(document.documentID)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return new Text("Loading");
                      } else {
                        DocumentSnapshot sessionDoc = snapshot.data;
                        if (!_sessionStarted) {
                          if (sessionDoc['hasCheckIn1'] == true &&
                              sessionDoc['hasCheckIn2'] == true) {
                            //Both users have checked in but session has not started
                            return new Text(
                              'Ready to Start Session!',
                              style: TextStyle(
                                  fontSize: 25.0, fontWeight: FontWeight.bold),
                            );
                          } else {
                            //Partner has not checked in
                            return new Text(
                              'Waiting for partner to check in...',
                              style: TextStyle(
                                  fontSize: 25.0, fontWeight: FontWeight.bold),
                            );
                          }
                        } else //session started
                          return new Text(
                            'Start Exercising!',
                            style: TextStyle(
                                fontSize: 25.0, fontWeight: FontWeight.bold),
                          );
                      }
                    }),
              ),
              Expanded(
                //Show timer
                child: Align(
                  alignment: FractionalOffset.center,
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: AnimatedBuilder(
                            animation: animationController,
                            builder: (BuildContext context, Widget child) {
                              return CustomPaint(
                                painter: TimerPainter(
                                    animation: animationController,
                                    backgroundColor: Colors.white,
                                    color: Theme.of(context).accentColor),
                              );
                            },
                          ),
                        ),
                        Align(
                          alignment: FractionalOffset.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text("Time left to work out",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat')),
                              AnimatedBuilder(
                                  animation: animationController,
                                  builder: (_, Widget child) {
                                    return Text(
                                      timerString,
                                      style:
                                          Theme.of(context).textTheme.display4,
                                    );
                                  })
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              _startFinishButton(context),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class TimerPainter extends CustomPainter {
  final Animation<double> animation;
  final Color backgroundColor;
  final Color color;

  TimerPainter({this.animation, this.backgroundColor, this.color})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * pi;
    canvas.drawArc(Offset.zero & size, pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
