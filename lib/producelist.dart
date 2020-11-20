import 'dart:math';
import 'package:AgriView/farmer_produce_item_card.dart';
import 'package:AgriView/models/FarmerProduceInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:AgriView/utils/constants.dart';
import 'dart:convert';

Future<List<FarmerProduceInfo>> fetchProduce(String landAginID) async {
  final response = await http.post(
    Uri.parse('${serverURL}production/farm/produce/list/landaginid'),
    headers: <String, String>{
      'X-AGIN-API-Key-Token': APIKEY,
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'AginID': landAginID,
    }),
  );
  print(response.body);
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    List<FarmerProduceInfo> listFarmerProduce;
    try {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      listFarmerProduce = items.map<FarmerProduceInfo>((json) {
        return FarmerProduceInfo.fromJson(json);
      }).toList();
    } catch (e) {
      print(e.toString());
    }

    return listFarmerProduce;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load farmers');
  }
}

class ProduceList extends StatefulWidget {
  @override
  _ProduceListState createState() => _ProduceListState();
}

class _ProduceListState extends State<ProduceList> {
  @override
  Widget build(BuildContext context) {
    Map data = {};
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    String name = data['name'].toString().split(" ")[0];
    String landAginID = data['landAginID'].toString();
    String farmerAginID = data['farmerAginID'].toString();
    String aggregatorAginID = data['aggregatorAginID'].toString();

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
        title: Text('$name Produce List'),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              print('hasdata${snapshot.hasData}');

              return Column(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: GridView.builder(
                          itemCount:
                              snapshot.data != null ? snapshot.data.length : 0,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 0,
                            crossAxisSpacing: 0,
                            childAspectRatio: 0.75,
                          ),
                          itemBuilder: (context, index) =>
                              FarmerProduceItemCard(
                                  product: snapshot.data[index],
                                  press: () {
                                    FarmerProduceInfo fProduceInfo =
                                        snapshot.data[index];
                                    Navigator.pushNamed(
                                        context, "/detailproduce",
                                        arguments: {
                                          'uuid':
                                              '${fProduceInfo.productUuid.UUID}',
                                          'name':
                                              '${fProduceInfo.productUuid.productName}',
                                          'filename':
                                              '${fProduceInfo.productUuid.fileName}',
                                          'id':
                                              '${fProduceInfo.productUuid.productID}',
                                          'farmerAginID': farmerAginID,
                                          'aggregatorAginID' : aggregatorAginID,
                                          'landAginID' : landAginID,
                                          'farmerName': name,
                                        }
                                        /*MaterialPageRoute(
                                        builder: (context) => DetailsScreen(
                            product: products[index],
                          ),
                                      )*/
                                        );
                                  })),
                    ),
                  ),
                ],
              );
            default:
              return CircularProgressIndicator();
          }
        },
        future: fetchProduce(landAginID),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          Navigator.popAndPushNamed(context, '/allproducelist',
              arguments: {'landAginID': landAginID});
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
