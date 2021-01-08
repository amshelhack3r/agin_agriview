import 'package:flutter/material.dart';

import '../elements/rounded_container.dart';

class FarmerInfo extends StatelessWidget {
  const FarmerInfo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Farmer Dashboard"),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Stack(
            children: [
              RoundedContainer(),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              _buildCard("farms.png", "Total \nFarms", "2"),
              _buildCard("produce.png", "Total \n Produce", "16")
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              _buildCard("income.png", "Total \n Income", "Ksh 100,000"),
              _buildCard("sales.png", "Total \n Sales", "Ksh 100,000")
            ],
          )
        ],
      )),
    );
  }

  _buildCard(String image, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [Image.asset("assets/images/${image}"), Text(title)],
          ),
          Text(subtitle)
        ],
      ),
    );
  }
}
