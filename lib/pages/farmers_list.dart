import 'package:flutter/material.dart';

import '../utils/hex_color.dart';

class FarmersListPage extends StatelessWidget {
  FarmersListPage({Key key}) : super(key: key);
  var width;
  var primaryColor;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: Text("Farmers List"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: _buildSelector(),
            ),
            SizedBox(height: 30),
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: 10,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemBuilder: (context, index) {
                  return _buildListItem(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildHeader() {
    var oneThird = width / 6;
    return Container(
      width: width,
      height: 50,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Image.asset(
            "assets/images/dashboard_mask.png",
            width: width,
            fit: BoxFit.cover,
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

  _buildSelector() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ActionChip(
              backgroundColor: primaryColor,
              label: Text(
                "256 Farmers",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {}),
          Row(
            children: [Icon(Icons.edit_location), Text("Filter")],
          )
        ],
      ),
    );
  }

  _buildListItem(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, "/FarmerInfo"),
      child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: HexColor("#8E8E8E"),
                blurRadius: 1.0,
                spreadRadius: 0.0,
                offset: Offset(2.0, 2.0), // shadow direction: bottom right
              )
            ],
          ),
          child: Column(
            children: [
              Image.asset("assets/images/my_avatar.png"),
              Text("James Makau"),
              Text("Machakos County")
            ],
          )),
    );
  }
}
