import 'dart:math';
import 'package:AgriView/models/Product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:AgriView/item_card.dart';
import 'package:http/http.dart' as http;
import 'package:AgriView/utils/constants.dart';
import 'dart:convert';

import 'api/api_provider.dart';
import 'models/message.dart';

class AllProduceList extends StatefulWidget {
  @override
  _AllProduceListState createState() => _AllProduceListState();
}

class _AllProduceListState extends State<AllProduceList> {
  Future<Message> _futureMessage;
  Map data = {};
  ApiProvider _apiProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiProvider = ApiProvider();
  }

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    String landAginID = data['landAginID'].toString();

    Color colorCode = Theme.of(context).primaryColor;

    final Random random = Random();

    generateRandomColor() {
      Color tmpColor = Color.fromARGB(
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
      );

      setState(() {
        colorCode = tmpColor;
      });
    }

    const kDefaultPaddin = 20.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Produce List'),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: (_futureMessage == null)
          ? FutureBuilder(
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.done:
                    print('hasdataproduce${snapshot.hasData}');

                    return Column(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            child: GridView.builder(
                                itemCount: snapshot.data != null
                                    ? snapshot.data.length
                                    : 0,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 0,
                                  crossAxisSpacing: 0,
                                  childAspectRatio: 0.75,
                                ),
                                itemBuilder: (context, index) => ItemCard(
                                      product: snapshot.data[index],
                                      press: () {
                                        Product product = snapshot.data[index];
                                        setState(() {
                                          _futureMessage =
                                              _apiProvider.createFarmProduce(
                                                  landAginID, product.UUID);
                                        });
                                      },
                                    )),
                          ),
                        ),
                      ],
                    );
                  default:
                    return CircularProgressIndicator();
                }
              },
              future: _apiProvider.fetchProduce(),
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: FutureBuilder<Message>(
                future: _futureMessage,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Center(child: Text(snapshot.data.message));
                  } else if (snapshot.hasError) {
                    return Center(child: Text("${snapshot.error}"));
                  }

                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 3.0,
                    ),
                  );
                },
              ),
            ),
    );
  }
}
