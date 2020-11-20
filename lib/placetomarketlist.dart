import 'dart:math';
import 'package:AgriView/blocs/BlocProvider.dart';
import 'package:AgriView/dashboard.dart';
import 'package:AgriView/farm.dart';
import 'package:AgriView/listview/IndexedListView.dart';
import 'package:flutter/material.dart';
import 'package:AgriView/world_time.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:AgriView/utils/constants.dart';
import 'dart:convert';
import 'package:AgriView/notfound.dart';

List<PlaceToMarketListingInfo> listPlaceToMarketListing;
List<PlaceToMarketListingInfo> dummySearchList;

Future <List<PlaceToMarketListingInfo>> fetchPlaceToMarketListing(String aggregatorAginID) async {

  final response =
  await http.post(Uri.parse('${serverURL}market/list/by/aggregator'),
    headers: <String, String>{
      'X-AGIN-API-Key-Token': APIKEY,
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'userAginID' : aggregatorAginID,
    }),
  );
  print(response.body);
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    listPlaceToMarketListing = items.map<PlaceToMarketListingInfo>((json) {
      return PlaceToMarketListingInfo.fromJson(json);
    }).toList();

    dummySearchList = List<PlaceToMarketListingInfo>();
    dummySearchList.addAll(listPlaceToMarketListing);

    return listPlaceToMarketListing;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load farmers');
  }
}

class PlaceToMarketListingInfo {
  final String cropName;
  final String pricePerUnitType;
  final String readyFromDate;
  final int quantityAvailable;
  final String producePhoto;
  final String farmerName;
  final String cultivationMode;
  final String produceStatus;
  final String unitType;


  PlaceToMarketListingInfo(this.cropName, this.pricePerUnitType, this.readyFromDate, this.quantityAvailable,this.producePhoto, this.farmerName, this.cultivationMode, this.produceStatus, this.unitType);

  factory PlaceToMarketListingInfo.fromJson(Map<String, dynamic> json) {
    return PlaceToMarketListingInfo(
      json['cropName'],
      json['pricePerUnitType'],
      json['readyFromDate'],
      json['quantityAvailable'],
      json['producePhoto'],
      json['farmerName'],
      json['cultivationMode'],
      json['produceStatus'],
      json['unitType'],
    );
  }

}

class PlaceToMarketList extends StatefulWidget {
  String aggregatorAginID;

  PlaceToMarketList(String aggregatorAginID){
    this.aggregatorAginID= aggregatorAginID;
  }

  @override
  _PlaceToMarketListState createState() => _PlaceToMarketListState(aggregatorAginID);
}

class _PlaceToMarketListState extends State<PlaceToMarketList> {
  Future<List<PlaceToMarketListingInfo>> futurePlaceToMarketListing;
  TextEditingController editingController = TextEditingController();
  int counter = 0;
  String aggregatorAginID = "";
  Map data = {};
  GlobalKey dashboardBottomNavigationKey = new GlobalKey(debugLabel: 'btm_app_bar');

  _PlaceToMarketListState(String aggregatorAginID){
    this.aggregatorAginID = aggregatorAginID;
  }


  void filterSearchResults(String query) {

    print('list${listPlaceToMarketListing.length}');
    if(query.isNotEmpty) {
      List<PlaceToMarketListingInfo> futureFarmers_2 = new List<PlaceToMarketListingInfo>();
      listPlaceToMarketListing.forEach((item) {
        if(item.farmerName.contains(query) ||
            item.cropName.contains(query)) {
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
        listPlaceToMarketListing.addAll(dummySearchList);
      });
    }

  }


  @override
  void initState() {
    /*Future.delayed(Duration.zero, () {
      setState(() {
        data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
        aggregatorAginID = data['aggregatorAginID'].toString();
      });
      futurePlaceToMarketListing = fetchPlaceToMarketListing(aggregatorAginID);
    });*/
    futurePlaceToMarketListing = fetchPlaceToMarketListing(aggregatorAginID);

  }

  @override
  Widget build(BuildContext context) {

    Color colorCode = Theme.of(context).primaryColor;
    final itemHeight = 100.0;
    final Random random = Random();
    generateRandomColor(){

      Color tmpColor = Color.fromARGB(
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
      ) ;

      setState(() {

        colorCode = tmpColor ;

      });

    }

    generateRandomColor();

    return Scaffold(
      backgroundColor: Colors.white,
      /*appBar: AppBar(
        title: Text('Choose a Location'),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        elevation: 0,
      ),*/
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0,20.0,10.0,10.0),
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
                    )
                ),

              ),
            ),
            Expanded(
              child: FutureBuilder(
                builder: (context, snapshot){
                  switch(snapshot.connectionState){
                    case ConnectionState.none:
                      return Center(child: CircularProgressIndicator());
                    case ConnectionState.active:
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    case ConnectionState.done:
                      print('hasdata${snapshot.hasData}');
                      if(!snapshot.hasData){
                        return NotFound().pageMessage(context, Icons.info,"No market listing yet");
                      }
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context,index){
                            PlaceToMarketListingInfo listingdata = snapshot.data[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
                              child: Card(
                                child: ListTile(
                                  onTap: (){
                                    //updateTime(index);
                                    //Map map = {'farmerAginID':listingdata.userAginID, 'name' : farmerdata.firstName, 'phone' : farmerdata.phoneNumber, 'aggregatorAginID' : aggregatorAginID};
                                    //Navigator.pushNamed(context, '/detailfarmer',arguments: map);
                                  },
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                            letterSpacing: 0.5
                                        ),
                                      ),

                                      /*Padding(
                                      padding: const EdgeInsets.fromLTRB(0,10.0,10.0,10.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            //width: 70,
                                            height: 20,
                                            decoration: ShapeDecoration(
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.grey[200],),
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                FlatButton(
                                                  child:Text(
                                                    "View Produce",
                                                    style: TextStyle(
                                                        color: Theme.of(context).primaryColor,
                                                        fontSize: 12,
                                                        letterSpacing: 1.0
                                                    ),
                                                  ),
                                                  onPressed: (){
                                                    Map map = {'farmerAginID':farmerdata.userAginID, 'name' : farmerdata.firstName};
                                                    Navigator.pushNamed(context, '/farmslist',arguments: map);
                                                    //Navigator.pushNamed(context, '/allproducelist');
                                                  },
                                                ),
                                                SizedBox(width: 5),
                                              ],
                                            ),
                                          ),

                                          SizedBox(width: 5),
                                          Container(
                                            //width: 70,
                                            height: 20,
                                            decoration: ShapeDecoration(
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.grey[200],),
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                FlatButton(
                                                  child: Text(
                                                    "View Farm",
                                                    style: TextStyle(
                                                        color: Theme.of(context).primaryColor,
                                                        fontSize: 12,
                                                        letterSpacing: 1.0
                                                    ),
                                                  ),
                                                  onPressed: (){
                                                    Map map = {'farmerAginID':farmerdata.userAginID, 'name' : farmerdata.firstName};
                                                    Navigator.pushNamed(context, '/farmslist',arguments: map);
                                                  },

                                                ),
                                                SizedBox(width: 5),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),*/

                                    ],
                                  ),
                                  leading: CircleAvatar(
                                    backgroundColor: colorCode,
                                    child: Text(
                                        listingdata.cropName.toString().substring(0,1).toUpperCase()
                                    ),
                                    //backgroundImage: AssetImage('assets/${locations[index].flag}'),
                                  ),
                                  trailing: Icon(
                                    Icons.navigate_next,
                                    //backgroundImage: AssetImage('assets/${locations[index].flag}'),
                                  ),
                                ),
                              ),
                            );
                          }

                      );
                  /* return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: IndexedListView(
                          itemHeight: itemHeight,
                          items: snapshot.data,
                          itemBuilder: (context,index){
                            FarmerInfo farmerdata = snapshot.data[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
                              child: Card(
                                child: ListTile(
                                  onTap: (){
                                    //updateTime(index);
                                    Map map = {'farmerAginID':farmerdata.userAginID, 'name' : farmerdata.firstName, 'phone' : farmerdata.phoneNumber};
                                    Navigator.pushNamed(context, '/detailfarmer',arguments: map);
                                  },
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Text(
                                        '${farmerdata.firstName} ${farmerdata.lastName}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18.0,
                                          letterSpacing: 0.0,
                                        ),
                                      ),
                                      Text(
                                        farmerdata.phoneNumber != null ? farmerdata.phoneNumber : "",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 15.0,
                                            letterSpacing: 0.5
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.grey.withOpacity(0.5),
                                        height: 5,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0,10.0,10.0,10.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              //width: 70,
                                              height: 20,
                                              decoration: ShapeDecoration(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.grey[200],),
                                                  borderRadius: BorderRadius.circular(30),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  FlatButton(
                                                    child:Text(
                                                      "View Produce",
                                                      style: TextStyle(
                                                          color: Theme.of(context).primaryColor,
                                                          fontSize: 12,
                                                          letterSpacing: 1.0
                                                      ),
                                                    ),
                                                    onPressed: (){
                                                      Map map = {'farmerAginID':farmerdata.userAginID, 'name' : farmerdata.firstName};
                                                      Navigator.pushNamed(context, '/farmslist',arguments: map);
                                                      //Navigator.pushNamed(context, '/allproducelist');
                                                    },
                                                  ),
                                                  SizedBox(width: 5),
                                                ],
                                              ),
                                            ),

                                            SizedBox(width: 5),
                                            Container(
                                              //width: 70,
                                              height: 20,
                                              decoration: ShapeDecoration(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.grey[200],),
                                                  borderRadius: BorderRadius.circular(30),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  FlatButton(
                                                    child: Text(
                                                      "View Farm",
                                                      style: TextStyle(
                                                          color: Theme.of(context).primaryColor,
                                                          fontSize: 12,
                                                          letterSpacing: 1.0
                                                      ),
                                                    ),
                                                    onPressed: (){
                                                      Map map = {'farmerAginID':farmerdata.userAginID, 'name' : farmerdata.firstName};
                                                      Navigator.pushNamed(context, '/farmslist',arguments: map);
                                                    },

                                                  ),
                                                  SizedBox(width: 5),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                    ],
                                  ),
                                  leading: CircleAvatar(
                                    backgroundColor: colorCode,
                                    child: Text(
                                        farmerdata.firstName.toString().substring(0,1).toUpperCase()
                                    ),
                                    //backgroundImage: AssetImage('assets/${locations[index].flag}'),
                                  ),
                                  //trailing: Visibility(
                                  //visible: !maybe,

                                  // ),
                                ),
                              ),
                            );
                          }



                        ),
                      );*/

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
