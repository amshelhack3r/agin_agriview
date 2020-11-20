import 'package:flutter/material.dart';

class DashboardItem extends StatelessWidget {
  final String title;
  final String icon;
  final dynamic color;
  final int total;

  DashboardItem({this.title, this.icon, this.color,this.total});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: (screenWidth - 40 - 17) / 2,
      height: (screenWidth - 40 - 17 - 30) / 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Color(color),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          child: Image.asset(icon,
              scale: 12,
               color: Colors.white,
          ),
          margin: EdgeInsets.only(bottom: 10),
        ),
        Text(title,
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
        Text(total.toString(),
            style: TextStyle(
                fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold))
      ]),
    );
  }
}