import 'package:flutter/material.dart';

import '../models/farm.dart';

class ProducePage extends StatefulWidget {
  final Map<String, dynamic> detail;
  ProducePage(this.detail, {Key key}) : super(key: key);

  @override
  _ProducePageState createState() => _ProducePageState();
}

class _ProducePageState extends State<ProducePage> {
  Farm farm;
  @override
  Widget build(BuildContext context) {
    setState(() {
      farm = widget.detail['farm'];
    });

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            _buildFirstCard(),
            SizedBox(
              height: 10,
            ),
            _buildSecondCard()
          ],
        ),
      ),
    );
  }

  _buildFirstCard() {
    TextStyle subText = TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.w700,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2.0,
              spreadRadius: 0.0,
              offset: Offset(2.0, 2.0), // shadow direction: bottom right
            )
          ],
        ),
        child: Column(
          children: [
            Text(
              farm.farmName,
              style: TextStyle(
                fontSize: 26,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              farm.farmLocation,
              style: TextStyle(
                fontSize: 22,
                color: Colors.grey,
                fontWeight: FontWeight.w400,
              ),
            ),
            Divider(
              color: Colors.grey,
              indent: 20,
              endIndent: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text('usage'),
                      Text(
                        farm.currentLandUse,
                        style: subText,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Mapped"),
                      Text(
                        "${farm.acreageMapped.toString()} acres",
                        style: subText,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text("approved"),
                      Text(
                        "${farm.acreageApproved.toString()} acres",
                        style: subText,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildSecondCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 2.0,
            spreadRadius: 0.0,
            offset: Offset(2.0, 2.0), // shadow direction: bottom right
          )
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: Text(
              "Actions",
              style: TextStyle(
                fontSize: 22,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Divider(
            color: Colors.grey,
            indent: 20,
            endIndent: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Image.asset("assets/images/visit.png", width: 50),
                    Text(
                      "Scout Land",
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Image.asset("assets/images/report.png", width: 50),
                    Text(
                      "Advise",
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Image.asset("assets/images/market.png", width: 50),
                    Text(
                      "Place to market",
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
