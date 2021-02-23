import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../injection.dart';
import '../state/user_provider.dart';
import '../utils/hex_color.dart';

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
          SizedBox(
            height: 70,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [_buildLeftContainer(), _buildRightContainer()],
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    ));
  }

  _buildHeader() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.width / 3,
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  context.watch<UserProvider>().fullname,
                  style: Theme.of(context).textTheme.headline5.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: 22,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 22,
                  ),
                  onPressed: () => _logout(),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              "Thursday, January 07",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
          ),
          // Positioned(
          //   bottom: -40,
          //   left: oneThird / 3,
          //   right: oneThird / 3,
          //   child: SizedBox(
          //     width: oneThird * 2,
          //     child: TextField(
          //       // style: TextStyle(color: Colors.amber),
          //       decoration: InputDecoration(
          //           suffixIcon: Icon(Icons.search),
          //           fillColor: Colors.white,
          //           filled: true,
          //           border: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(40)),
          //           hintText: "Search",
          //           hintStyle: TextStyle(color: Colors.black)),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  _buildLeftContainer() {
    var width = MediaQuery.of(context).size.width;
    return Container(
      width: (width / 2) - 20,
      height: 300,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor,
              blurRadius: 2.0,
              spreadRadius: 0.0,
              offset: Offset(2.0, 2.0), // shadow direction: bottom right
            )
          ],
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Theme.of(context).primaryColor)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset("assets/images/income.png"),
                    Text(
                      "Total \n Income",
                      style: Theme.of(context).textTheme.headline6,
                    )
                  ],
                ),
                Container(
                  height: 50,
                  width: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 2.0,
                        spreadRadius: 0.0,
                        offset:
                            Offset(2.0, 2.0), // shadow direction: bottom right
                      )
                    ],
                  ),
                  child: Text(
                    "Ksh 100.00",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset("assets/images/income.png"),
                    Text(
                      "Total \n Income",
                      style: Theme.of(context).textTheme.headline6,
                    )
                  ],
                ),
                Container(
                  height: 50,
                  width: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 2.0,
                        spreadRadius: 0.0,
                        offset:
                            Offset(2.0, 2.0), // shadow direction: bottom right
                      )
                    ],
                  ),
                  child: Text("Ksh 100.00"),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
              child: GestureDetector(
            onTap: () {},
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(10.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/sell_input.png",
                    width: 50,
                  ),
                  Text(
                    "Sell Inputs",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }

  _buildRightContainer() {
    var width = MediaQuery.of(context).size.width;
    return Container(
      width: (width / 2) - 20,
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildCard("assets/images/register_group.png", "Register \n Group"),
          buildCard("assets/images/register_farmer.png", "Register \n Farmer",
              routeName: "/RegisterFarmerPage"),
        ],
      ),
    );
  }

  buildCard(String imageString, String title, {String routeName}) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, routeName),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        // width: double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor,
              blurRadius: 2.0,
              spreadRadius: 0.0,
              offset: Offset(2.0, 2.0), // shadow direction: bottom right
            )
          ],
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Image.asset(
              imageString,
              width: 81,
              height: 48,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: HexColor("#707070"),
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }

  _logout() async {
    var prefs = getIt.get<SharedPreferences>();
    if (await prefs.clear()) {
      Navigator.pushNamed(context, '/AuthPage');
    }
  }
}
