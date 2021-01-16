import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/db_provider.dart';

class AddFarm extends StatefulWidget {
  final String name;
  const AddFarm({Key key, this.name}) : super(key: key);

  @override
  _AddFarmState createState() => _AddFarmState();
}

class _AddFarmState extends State<AddFarm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text("eg ${widget.name} ${_randomCounty()} farm"),
        ),
      ),
    );
  }

  String _randomCounty() {
    var counties = context.watch<DatabaseProvider>().county;
    var random = Random();
    var county = counties[random.nextInt(4)];
    return county.countyName;
  }
}
