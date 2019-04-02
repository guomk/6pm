import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchSession extends StatefulWidget {
  @override
  SearchSessionState createState() => new SearchSessionState();
}

class SearchSessionState extends State<SearchSession> {
  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  List names = new List();
  List filteredNames = new List();
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Search');

  SearchSessionState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredNames = names;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  Future<QuerySnapshot> getGyms() async {
    CollectionReference col = Firestore.instance.collection('Gym');
    col.getDocuments().then((doc) {
      int gymCount = doc.documents.length;
      for (int i = 0; i < gymCount; i++) {
        DocumentSnapshot gym = doc.documents[i];
        names.add(gym.documentID);
      }
    });
    setState(() {
      filteredNames = names;
    });
    return col.getDocuments();
  }

  @override
  void initState() {
    super.initState();
    getGyms();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: Container(
        child: _buildList(),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: _appBarTitle,
      leading: new IconButton(
        icon: _searchIcon,
        onPressed: _searchPressed,
      ),
    );
  }

  Widget _buildList() {
    if (!(_searchText.isEmpty)) {
      List tempList = new List();
      for (int i = 0; i < names.length; i++) {
        if (names[i]
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(names[i]);
        }
      }
      filteredNames = tempList;

      return ListView.builder(
        itemCount: filteredNames.length,
        itemBuilder: (BuildContext context, int index) {
          return new ListTile(
            title: Text(filteredNames[index]),
            onTap: () => {
                  _filter.text = filteredNames[index],
                  Navigator.pop(context, filteredNames[index])
                },
          );
        },
      );
    } else {
      return FutureBuilder(
          future: getGyms(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                return new ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    final DocumentSnapshot gymDoc =
                        snapshot.data.documents[index];
                    return new ListTile(
                      title: Text(gymDoc.documentID),
                      onTap: () => {
                            _filter.text = gymDoc.documentID,
                            Navigator.pop(context, gymDoc.documentID)
                          },
                    );
                  },
                );
              }
            } else {
              return Center(child: new CircularProgressIndicator());
            }
          });
    }
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search), hintText: 'Search for a gym'),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Search');
        filteredNames = names;
        _filter.clear();
      }
    });
  }
}
