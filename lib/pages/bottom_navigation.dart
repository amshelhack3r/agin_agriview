import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  @override
  BottomNavigationState createState() {
    return new BottomNavigationState();
  }
}

class BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      bottomNavigationBar: new BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (newIndex) => setState((){_currentIndex = newIndex;}),
        items: [
          new BottomNavigationBarItem(
              icon: new Icon(Icons.add),
              title: new Text("trends")
          ),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.location_on),
              title: new Text("feed")
          ),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.people),
              title: new Text("community")
          ),
        ],
      ),
      body: new IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          //new YourCustomTrendsWidget(),
          //new YourCustomFeedWidget(),
          //new YourCustomCommunityWidget(),
        ],
      ),
    );
  }
}