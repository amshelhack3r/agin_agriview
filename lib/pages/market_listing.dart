import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../core/repository/api_repository.dart';
import '../injection.dart';
import '../models/product.dart';
import '../utils/hex_color.dart';
import 'elements/dialogs.dart';

class MarketListingPage extends StatefulWidget {
  final Product product;
  MarketListingPage(this.product, {Key key}) : super(key: key);

  @override
  _MarketListingPageState createState() => _MarketListingPageState();
}

class _MarketListingPageState extends State<MarketListingPage> {
  var width;

  var primaryColor;
  Future<List<dynamic>> _getListing;

  @override
  void initState() {
    super.initState();
    _getListing =
        getIt.get<ApiRepository>().getProductListing(widget.product.uuid);
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: Text("Market Listing"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder(
                future: _getListing,
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.hasData) {
                    var products = snapshot.data;
                    if (products.length > 0) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child:
                                    _buildListItem(context, products[index]));
                          });
                    } else {
                      return Center(child: Text("No listings for the product"));
                    }
                  } else if (snapshot.hasError) {
                    Sentry.captureException(snapshot.error.toString());
                    return Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("No listings for ${widget.product.productName}"),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Go Back"))
                        ],
                      ),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildHeader() {
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
        ],
      ),
    );
  }

  _buildListItem(BuildContext context, Map map) {
    var amount = map['unitPriceTypesObjectList'][0]['amount'];
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/ProductInfoPage',
          arguments: widget.product),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.only(right: 10),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(widget.product.initials,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: Colors.white)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(map['BC'],
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: HexColor("#8E8E8E"))),
                Text(map['county']),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("PRICE",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: HexColor("#8E8E8E"))),
                Text("Ksh ${amount.toString()}",
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: Colors.black54)),
              ],
            ),
            // Column()
          ],
        ),
      ),
    );
  }
}
