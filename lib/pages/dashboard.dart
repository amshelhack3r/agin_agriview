import 'package:AgriView/core/repository/api_repository.dart';
import 'package:AgriView/core/repository/repository.dart';
import 'package:AgriView/models/statistic_info.dart';
import 'package:AgriView/pages/elements/dialogs.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
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
  Future<StatisticsInfo> _info;
  Repository _repository = getIt.get<ApiRepository>();
  @override
  void initState() {
    super.initState();
    _info = getIt
        .get<ApiRepository>()
        .fetchStatistics(context.read<UserProvider>().aginId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
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
        child: FutureBuilder(
          future: _info,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              StatisticsInfo stats = snapshot.data;
              return Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/images/register_farmer.png",
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                            Text(
                              "Farmers",
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
                          ),
                          child: Text(
                            stats.totalFarmers.toString(),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/images/farms.png",
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                            Text(
                              "Acerage",
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
                          ),
                          child: Text(
                            "${stats.totalAcreage} acres",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/images/income.png",
                              width: 30,
                            ),
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
                                offset: Offset(
                                    2.0, 2.0), // shadow direction: bottom right
                              )
                            ],
                          ),
                          child: Text(
                            "Ksh ${stats.totalIncome.toString()}",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/images/income.png",
                              width: 30,
                            ),
                            Text(
                              "Total \n Sales",
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
                                offset: Offset(
                                    2.0, 2.0), // shadow direction: bottom right
                              )
                            ],
                          ),
                          child: Text("Ksh ${stats.totalSales.toString()}"),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              var err = snapshot.error;

              if (err is DioError) {
                Future.delayed(Duration(seconds: 90),
                    () => Dialogs.messageDialog(context, true, err.message));
              }
              return Container();
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }

  _buildRightContainer() {
    var width = MediaQuery.of(context).size.width;
    return Container(
      width: (width / 2) - 20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildCard("assets/images/register_farmer.png", "Register \n Farmer",
              routeName: "/RegisterFarmerPage", isActive: true),
          buildCard("assets/images/register_group.png", "Register \n Group",
              isActive: false),
          buildCard("assets/images/sell_input.png", "Sell \n inputs",
              isActive: false),
        ],
      ),
    );
  }

  buildCard(String imageString, String title,
      {String routeName, bool isActive}) {
    return GestureDetector(
      onTap: () => {
        isActive
            ? Navigator.pushNamed(context, routeName)
            : showToast("COMING SOON")
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        // width: double.maxFinite,
        decoration: isActive
            ? BoxDecoration(
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
              )
            : null,
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
                  color: isActive ? HexColor("#707070") : Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
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
