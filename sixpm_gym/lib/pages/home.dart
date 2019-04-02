import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './widgets/sessionMain.dart';
import './gym/gym.dart';
import './profile/profile.dart';
import './gym/weather.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key, @required this.user}) : super(key: key);
  final FirebaseUser user;
  @override
  State<StatefulWidget> createState() {
    return new _HomePageState(user);
  }
}

class _HomePageState extends State<HomePage> {
  final FirebaseUser user;
  _HomePageState(this.user);
  int _currentIndex = 1;

  void _logoutDialog(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
            title: new Text('Logout'),
            content: new Text('Do you want to logout?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => signOut(),
                child: new Text('Yes'),
              ),
            ],
          ),
    );
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
                title: new Text('Logout'),
                content: new Text('Do you want to logout?'),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text('No'),
                  ),
                  new FlatButton(
                    onPressed: () => signOut(),
                    child: new Text('Yes'),
                  ),
                ],
              ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [
      // GymPage(storage: GymStorage()),
      WeatherPage(),
      SessionMainPage(),
      MyProfile(
        user: user,
      ),
    ];

    return new WillPopScope(
        onWillPop: _onWillPop,
        child: new Scaffold(
          appBar: AppBar(
            title: Text('Home'),
            automaticallyImplyLeading: false,
            actions: <Widget>[
              FlatButton(
                textColor: Colors.white,
                onPressed: () => _logoutDialog(context),
                child: Text('Logout'),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          body: _children[_currentIndex],
          bottomNavigationBar: new BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: onTabTapped,
            items: [
              new BottomNavigationBarItem(
                  icon: new Icon(Icons.map), title: new Text("gym")),
              new BottomNavigationBarItem(
                  icon: new Icon(Icons.home), title: new Text("session")),
              new BottomNavigationBarItem(
                  icon: new Icon(Icons.person), title: new Text("profile"))
            ],
          ),
        ));
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void signOut() async {
    FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
  }
}
