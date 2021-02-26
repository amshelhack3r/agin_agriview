import 'package:AgriView/models/message.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';

import '../core/repository/api_repository.dart';
import '../injection.dart';
import '../models/farm.dart';
import '../models/product.dart';
import 'elements/dialogs.dart';

class ProducePage extends StatefulWidget {
  final Map<String, dynamic> detail;
  ProducePage(this.detail, {Key key}) : super(key: key);

  @override
  _ProducePageState createState() => _ProducePageState();
}

class _ProducePageState extends State<ProducePage> {
  Farm farm;
  GlobalKey _scaffoldState = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    setState(() {
      farm = widget.detail['farm'];
    });

    return Scaffold(
        key: _scaffoldState,
        appBar: AppBar(),
        body: Builder(builder: (BuildContext ctx) {
          return Container(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                _buildFirstCard(),
                SizedBox(
                  height: 10,
                ),
                _buildSecondCard(ctx),
                SizedBox(
                  height: 10,
                ),
                _buildProduce()
              ],
            ),
          );
        }));
  }

  _buildFirstCard() {
    TextStyle subText = TextStyle(
      color: Colors.black,
      fontSize: 12,
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
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              farm.farmLocation,
              style: TextStyle(
                fontSize: 12,
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

  _buildSecondCard(BuildContext myContext) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: Text(
                "Actions",
                style: TextStyle(
                  fontSize: 12,
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
                      Image.asset("assets/images/visit.png", width: 40),
                      Text(
                        "Scout Land",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset("assets/images/report.png", width: 40),
                      Text(
                        "Advise",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Scaffold.of(myContext).showBottomSheet(
                        (context) => Container(
                          height: MediaQuery.of(context).size.width,
                          width: double.infinity,
                          child: FutureBuilder(
                            future: getIt.get<ApiRepository>().fetchProduce(),
                            builder: (context,
                                AsyncSnapshot<List<Product>> snapshot) {
                              if (snapshot.hasData) {
                                var data = snapshot.data;
                                return Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: ListView.builder(
                                    itemCount: data.length,
                                    itemBuilder: (context, index) {
                                      Product p = data[index];
                                      return ListTile(
                                        leading: Image.network(
                                          p.fileName,
                                          width: 50,
                                          height: 50,
                                        ),
                                        title: Text(p.productName),
                                        trailing: ElevatedButton(
                                          child: Text("add"),
                                          onPressed: () =>
                                              addProduce(p, myContext),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                Future.delayed(
                                    Duration(milliseconds: 1),
                                    () => Dialogs.messageDialog(context, true,
                                        snapshot.error.toString()));
                                return Container();
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Image.asset("assets/images/market.png", width: 40),
                        Text(
                          "Add Produce",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildProduce() {
    return Expanded(
      child: FutureBuilder(
        future: getIt.get<ApiRepository>().fetchLandProduce(farm.landAginId),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return Wrap(
                children: [
                  ...snapshot.data.map((produce) {
                    return Container(
                      child: Column(
                        children: [
                          CachedNetworkImage(
                            imageUrl: produce['fileName'],
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Center(
                              child: CircularProgressIndicator(
                                  value: downloadProgress.progress),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(produce['name']),
                          SizedBox(
                            height: 10,
                          ),
                          RaisedButton(
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            onPressed: () async {
                              var msg = await Navigator.pushNamed(
                                  context, '/MarketForm',
                                  arguments: this.widget.detail);
                              Fimber.i(msg.toString());
                              Dialogs.messageDialog(
                                  context, false, msg.toString());
                            },
                            child: Text('market'),
                          )
                        ],
                      ),
                    );
                  })
                ],
              );
            } else {
              return Center(
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: () => {},
                  child: Text("ADD PRODUCE"),
                ),
              );
            }
          } else if (snapshot.hasError) {
            Dialogs.messageDialog(context, true, snapshot.error.toString());
            return Container();
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  void addProduce(Product p, BuildContext cx) {
    Farm f = widget.detail['farm'];
    var _repository = getIt.get<ApiRepository>();
    Map params = {"landAginID": f.landAginId, "productUUID": p.uuid};
    _repository
        .addProduce(params)
        .then((value) => Navigator.pop(cx))
        .catchError((err) => {
              Future.delayed(Duration(milliseconds: 1),
                  () => Dialogs.messageDialog(context, true, err.toString()))
            });
  }
}
