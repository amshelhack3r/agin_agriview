import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductInfo extends StatefulWidget {
  final Product product;
  ProductInfo(this.product, {Key key}) : super(key: key);

  @override
  _ProductInfoState createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product info"),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              _buildFirstCard(),
              SizedBox(height: 30),
              _buildSecondCard(),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  _buildFirstCard() {
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedNetworkImage(
                imageUrl: widget.product.fileName,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) => Icon(Icons.error),
                width: 100,
              ),
              Text(
                widget.product.productName,
                style: TextStyle(
                  // color: Colors.grey,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
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
                    Text("Planting Date"),
                    Text("01 Jan 2020"),
                  ],
                ),
                Column(
                  children: [
                    Text("Date of harvest"),
                    Text("01 Jan 2020"),
                  ],
                ),
                Column(
                  children: [
                    Text("Quantity"),
                    Text("2 Tonnes"),
                  ],
                ),
              ],
            ),
          )
        ],
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
              "Farming Details",
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
                    Image.asset("assets/images/irrigation.png", width: 50),
                    Text(
                      "irrigation",
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Image.asset("assets/images/greenhouse.png", width: 50),
                    Text(
                      "Green House",
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Image.asset("assets/images/agricultural.png", width: 50),
                    Text(
                      "3 acres",
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
