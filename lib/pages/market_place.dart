import 'package:flutter/material.dart';

import '../utils/hex_color.dart';
import '../models/product.dart';

class MarketPlaceList extends StatelessWidget {
  MarketPlaceList({Key key}) : super(key: key);
  var width;
  var primaryColor;
  final List products = [
    Product(name: "strawberry"),
    Product(name: "watermelon"),
    Product(name: "pineapples"),
    Product(name: "oranges"),
    Product(name: "bananas"),
    Product(name: "lemons"),
    Product(name: "pawpaw"),
  ];
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: Text("Market Place"),
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
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemBuilder: (context, index) {
                  Product p = products[index];
                  return _buildListItem(p, context);
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
          Text(
            "Categories",
            style: TextStyle(color: Colors.white),
          ),
          Row(
            children: [Icon(Icons.edit_location), Text("Filter")],
          )
        ],
      ),
    );
  }

  _buildListItem(Product product, BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/MarketListingPage',
          arguments: product),
      child: Container(
          padding: const EdgeInsets.all(5),
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
              Image.asset(
                "assets/images/${product.name}.png",
                width: 100,
              ),
              Text(product.name),
            ],
          )),
    );
  }
}
