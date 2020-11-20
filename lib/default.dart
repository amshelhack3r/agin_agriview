
import 'dart:convert';
import 'package:AgriView/dashboard_item.dart';
import 'package:AgriView/notfound.dart';
import 'package:AgriView/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

StatisticsInfo statisticsInfo;
String responseMessage = "";

Future <StatisticsInfo> fetchStatistics(String aggregatorAginID) async {
  final response =
  await http.post(Uri.parse('${serverURL}aggregator/stats'),
    headers: <String, String>{
      'X-AGIN-API-Key-Token': APIKEY,
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'AginID' : aggregatorAginID,
    }),
  );
  print(response.body);
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return StatisticsInfo.fromJson(jsonDecode(response.body));

  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    Message message = Message.fromJson(jsonDecode(response.body));
    responseMessage = message.message;
  }
}

class StatisticsInfo {
  final int totalFarmers;
  final int totalAcreage;
  final int totalIncome;
  final int totalSales;

  StatisticsInfo(this.totalFarmers, this.totalAcreage, this.totalIncome,
      this.totalSales);

  factory StatisticsInfo.fromJson(Map<String, dynamic> json) {
    return StatisticsInfo(
      json['totalFarmers'],
      json['totalAcreage'],
      json['totalIncome'],
      json['totalSales'],

    );
  }

}

class Message {
  final String message;
  final String responsecode;

  Message({this.message, this.responsecode});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'],
      responsecode: json['responsecode'],
    );
  }
}

class Default extends StatefulWidget {
  String aggregatorAginID;

  @override
  _DefaultState createState() => _DefaultState(aggregatorAginID);

  Default(String aggregatorAginID){
   this.aggregatorAginID = aggregatorAginID;
  }
}

class _DefaultState extends State<Default> {
  //get the arguments
  Map data = {};
  String aggregatorAginID;
  Future<StatisticsInfo> _futureStatisticsInfo;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _DefaultState(String aggregatorAginID){
    this.aggregatorAginID = aggregatorAginID;
  }


  @override
  void initState() {

    _futureStatisticsInfo = fetchStatistics(aggregatorAginID);

    setState(() {
      if(responseMessage != ""){
         _scaffoldKey.currentState.showSnackBar(
             SnackBar(
                 content: Text(responseMessage)
             )
         );
      }
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
              builder: (context, snapshot){
                switch(snapshot.connectionState){
                  case ConnectionState.none:
                      return Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.done:
                    if(!snapshot.hasData){
                      return NotFound().pageMessage(context, Icons.info,"No statistics yet");
                    }
                    StatisticsInfo statisticsInfo = snapshot.data;
                    return Column(children: [
                      Wrap(
                        spacing: 17,
                        runSpacing: 17,
                        children: [
                          DashboardItem(title: 'Total Farmers', icon: "assets/images/user_add.png", color: 0xffFED525, total: statisticsInfo.totalFarmers),
                          DashboardItem(title: 'Total Acreage', icon: "assets/images/farm_grey.png", color: 0xffFD637B, total: statisticsInfo.totalAcreage),
                          DashboardItem(
                              title: 'Total Income',
                              icon: "assets/images/income.png",
                              color: 0xff21CDFF,
                              total: statisticsInfo.totalIncome
                          ),
                          DashboardItem(title: 'Total Sales', icon: "assets/images/sales.png", color: 0xff7585F6,total: statisticsInfo.totalSales)
                        ],
                      ),
                    ]);
                  default:
                    return CircularProgressIndicator();

                }
              },
              future: _futureStatisticsInfo,
            )
        )
    );
  }
}
