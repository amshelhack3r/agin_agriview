import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'api/api_provider.dart';
import 'blocs/BlocProvider.dart';
import 'dashboard.dart';
import 'models/market_listing_info.dart';
import 'notfound.dart';

class PlaceToMarketList extends StatefulWidget {
  String aggregatorAginID;

  PlaceToMarketList(String aggregatorAginID) {
    this.aggregatorAginID = aggregatorAginID;
  }

  @override
  _PlaceToMarketListState createState() =>
      _PlaceToMarketListState(aggregatorAginID);
}

class _PlaceToMarketListState extends State<PlaceToMarketList> {
  Future<List<PlaceToMarketListingInfo>> futurePlaceToMarketListing;
  TextEditingController editingController = TextEditingController();
  ApiProvider _apiProvider;
  int counter = 0;
  String aggregatorAginID = "";
  Map data = {};
  GlobalKey dashboardBottomNavigationKey =
      new GlobalKey(debugLabel: 'btm_app_bar');

  _PlaceToMarketListState(String aggregatorAginID) {
    this.aggregatorAginID = aggregatorAginID;
  }

  @override
  void initState() {
    super.initState();
    _apiProvider = ApiProvider();
  }

  void filterSearchResults(String query) async {
    var listPlaceToMarketListing =
        await _apiProvider.fetchPlaceToMarketListing(aggregatorAginID);
    if (query.isNotEmpty) {
      List<PlaceToMarketListingInfo> futureFarmers_2 =
          new List<PlaceToMarketListingInfo>();

      listPlaceToMarketListing.forEach((item) {
        if (item.farmerName.contains(query) || item.cropName.contains(query)) {
          futureFarmers_2.add(item);
        }
      });
      setState(() {
        listPlaceToMarketListing.clear();
        listPlaceToMarketListing.addAll(futureFarmers_2);
      });
      return;
    } else {
      setState(() {
        listPlaceToMarketListing.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color colorCode = Theme.of(context).primaryColor;
    final itemHeight = 100.0;
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

    generateRandomColor();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0.0)),
                      borderSide: BorderSide(
                        color: Colors.grey[100],
                        width: 1,
                      ),
                    )),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Center(child: CircularProgressIndicator());
                    case ConnectionState.active:
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    case ConnectionState.done:
                      print('hasdata${snapshot.hasData}');
                      if (!snapshot.hasData) {
                        return NotFound().pageMessage(
                            context, Icons.info, "No market listing yet");
                      }
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            PlaceToMarketListingInfo listingdata =
                                snapshot.data[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2.0, horizontal: 4.0),
                              child: Card(
                                child: ListTile(
                                  onTap: () {
                                    //updateTime(index);
                                    //Map map = {'farmerAginID':listingdata.userAginID, 'name' : farmerdata.firstName, 'phone' : farmerdata.phoneNumber, 'aggregatorAginID' : aggregatorAginID};
                                    //Navigator.pushNamed(context, '/detailfarmer',arguments: map);
                                  },
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Text(
                                        '${listingdata.cropName}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                        ),
                                      ),
                                      Text(
                                        listingdata.farmerName,
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14.0,
                                            letterSpacing: 0.5),
                                      ),
                                    ],
                                  ),
                                  leading: CircleAvatar(
                                    backgroundColor: colorCode,
                                    child: Text(listingdata.cropName
                                        .toString()
                                        .substring(0, 1)
                                        .toUpperCase()),
                                    //backgroundImage: AssetImage('assets/${locations[index].flag}'),
                                  ),
                                  trailing: Icon(
                                    Icons.navigate_next,
                                    //backgroundImage: AssetImage('assets/${locations[index].flag}'),
                                  ),
                                ),
                              ),
                            );
                          });
                    default:
                      return CircularProgressIndicator();
                  }
                },
                future: futurePlaceToMarketListing,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'placeMarket_farmerList',
        onPressed: () {
          //final BottomNavigationBar navigationBar = dashboardBottomNavigationKey.currentState;
          //navigationBar.onTap(2);
          IncrementBloc bloc = BlocProvider.of<IncrementBloc>(context);
          bloc.incrementCounter.add(2);
          //Navigator.pushNamed(context, '/farmerlist', arguments: {'aggregatorAginID':aggregatorAginID});
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
