import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({Key key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          _buildHeader(),
        ],
      ),
    ));
  }

  _buildHeader() {
    var oneThird = MediaQuery.of(context).size.width / 3;
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.width / 2,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Image.asset(
            "assets/images/dashboard_mask.png",
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Farmer Sam",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800),
                ),
                IconButton(
                    icon: Icon(
                      Icons.notifications,
                      color: Colors.white,
                      size: 40,
                    ),
                    onPressed: () {})
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              "Thursday, January 07",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Positioned(
            bottom: -40,
            left: oneThird / 2,
            right: oneThird / 2,
            child: SizedBox(
              width: oneThird * 2,
              child: TextField(
                // style: TextStyle(color: Colors.amber),
                decoration: InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                    hintText: "Search",
                    hintStyle: TextStyle(color: Colors.black)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
