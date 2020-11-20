import 'dart:math';
import 'package:AgriView/models/Product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:AgriView/item_card.dart';
import 'package:http/http.dart' as http;
import 'package:AgriView/utils/constants.dart';
import 'dart:convert';

Future<Message> createFarmProduce(String landAginID, String productUUID) async {
  final http.Response response = await http.post(
    Uri.parse('${serverURL}production/farm/produce/register'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'X-AGIN-API-Key-Token': APIKEY,
    },
    body: jsonEncode(<String, String>{
      'landAginID': landAginID,
      'productUUID': productUUID,
    }),
  );

  if (response.statusCode == 201) {
    return Message.fromJson(json.decode(response.body));
  } else {
    return Message.fromJson(json.decode(response.body));
  }
}

class Message {
  final String message;
  final String responsecode;

  Message({this.message, this.responsecode});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'],
      responsecode: json['responsecode'],
    );
  }
}

Future<List<Product>> fetchProduce() async {
  final response = await http.post(
    Uri.parse('${serverURL}product/list'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'X-AGIN-API-Key-Token': APIKEY,
    },
    body: jsonEncode(<String, String>{
      'CategoryID': "1",
    }),
  );
print(response.body);
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    List<Product> listProduce = items.map<Product>((json) {
      return Product.fromJson(json);
    }).toList();
    return listProduce;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load farmers');
  }
}

class AllProduceList extends StatefulWidget {
  @override
  _AllProduceListState createState() => _AllProduceListState();
}

class _AllProduceListState extends State<AllProduceList> {
  Future<Message> _futureMessage;
  Map data = {};

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
                                      press: (){
                                        Product product = snapshot.data[index];
                                        print('UUID${product.UUID}');
                                        setState(() {
                                          _futureMessage = createFarmProduce(landAginID, product.UUID);
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
              future: fetchProduce(),
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
