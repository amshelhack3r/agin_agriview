import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../api/api_provider.dart';
import '../models/FarmerProduceInfo.dart';
import 'farmer_produce_item_card.dart';

class ProduceList extends StatefulWidget {
  @override
  _ProduceListState createState() => _ProduceListState();
}

class _ProduceListState extends State<ProduceList> {
  ApiProvider _apiProvider;

  @override
  void initState() {
    super.initState();
    _apiProvider = ApiProvider();
  }

  @override
  Widget build(BuildContext context) {
    Map data = {};
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    String name = data['name'].toString().split(" ")[0];
    String landAginID = data['landAginID'].toString();
    String farmerAginID = data['farmerAginID'].toString();
    String aggregatorAginID = data['aggregatorAginID'].toString();

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
                                          'aggregatorAginID': aggregatorAginID,
                                          'landAginID': landAginID,
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
        future: _apiProvider.fetchProduceByLandAgin(landAginID),
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
