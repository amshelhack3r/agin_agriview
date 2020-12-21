import 'package:flutter/material.dart';

import '../api/api_provider.dart';
import '../models/statistic_info.dart';
import '../notfound.dart';
import 'dashboard_item.dart';

class Default extends StatefulWidget {
  String aggregatorAginID;

  @override
  _DefaultState createState() => _DefaultState(aggregatorAginID);

  Default(String aggregatorAginID) {
    this.aggregatorAginID = aggregatorAginID;
  }
}

class _DefaultState extends State<Default> {
  //get the arguments
  Map data = {};
  String aggregatorAginID;
  ApiProvider _apiProvider;
  Future<StatisticsInfo> _futureStatisticsInfo;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _DefaultState(String aggregatorAginID) {
    this.aggregatorAginID = aggregatorAginID;
  }

  @override
  void initState() {
    _apiProvider = ApiProvider();
    _futureStatisticsInfo = _apiProvider.fetchStatistics(aggregatorAginID);

    setState(() {
      // if (responseMessage != "") {
      //   _scaffoldKey.currentState
      //       .showSnackBar(SnackBar(content: Text(responseMessage)));
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    //data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;

    return Scaffold(
        key: _scaffoldKey,
        body: Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(20, 20, 20, 30),
            child: FutureBuilder(
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.done:
                    if (!snapshot.hasData) {
                      return NotFound().pageMessage(
                          context, Icons.info, "No statistics yet");
                    }
                    StatisticsInfo statisticsInfo = snapshot.data;
                    return Column(children: [
                      Wrap(
                        spacing: 17,
                        runSpacing: 17,
                        children: [
                          DashboardItem(
                              title: 'Total Farmers',
                              icon: "assets/images/user_add.png",
                              color: 0xffFED525,
                              total: statisticsInfo.totalFarmers),
                          DashboardItem(
                              title: 'Total Acreage',
                              icon: "assets/images/farm_grey.png",
                              color: 0xffFD637B,
                              total: statisticsInfo.totalAcreage),
                          DashboardItem(
                              title: 'Total Income',
                              icon: "assets/images/income.png",
                              color: 0xff21CDFF,
                              total: statisticsInfo.totalIncome),
                          DashboardItem(
                              title: 'Total Sales',
                              icon: "assets/images/sales.png",
                              color: 0xff7585F6,
                              total: statisticsInfo.totalSales)
                        ],
                      ),
                    ]);
                  default:
                    return CircularProgressIndicator();
                }
              },
              future: _futureStatisticsInfo,
            )));
  }
}
