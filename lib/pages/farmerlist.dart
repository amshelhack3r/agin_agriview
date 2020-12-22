import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../api/api_provider.dart';
import '../models/farmer_info.dart';
import '../utils/world_time.dart';
import 'elements/notfound.dart';

List<FarmerInfo> listFarmers;
List<FarmerInfo> dummySearchList;

class FarmerList extends StatefulWidget {
  String aggregatorAginID;

  FarmerList(String aggregatorAginID) {
    this.aggregatorAginID = aggregatorAginID;
  }

  @override
  _FarmerListState createState() => _FarmerListState(aggregatorAginID);
}

class _FarmerListState extends State<FarmerList> {
  Future<List<FarmerInfo>> futureFarmers;
  TextEditingController editingController = TextEditingController();
  int counter = 0;
  String aggregatorAginID = "";
  Map data = {};
  ApiProvider _apiProvider;

  _FarmerListState(String aggregatorAginID) {
    this.aggregatorAginID = aggregatorAginID;
  }

  List<WorldTime> locations = [
    WorldTime(
      url: 'Europe/London',
      location: 'Peter Mwangi',
      flag: '25472000000',
    ),
    WorldTime(
        url: 'Europe/Berlin',
        location: 'Michael Githinji',
        flag: '25472000000'),
    WorldTime(
        url: 'Africa/Cairo', location: 'Moses Kuria', flag: '25472000000'),
    WorldTime(
        url: 'Africa/Nairobi', location: 'Karisa Maitha', flag: '25472000000'),
  ];

  void updateTime(index) async {
    WorldTime instance = locations[index];
    await instance.getWorldTime();
    //go back home page with the new location details
    Navigator.pop(context, {
      'location': instance.location,
      'flag': instance.flag,
      'time': instance.time,
      'isDayTime': instance.isDayTime,
    });
  }

  void filterSearchResults(String query) {
    print('list${listFarmers.length}');
    if (query.isNotEmpty) {
      List<FarmerInfo> futureFarmers_2 = new List<FarmerInfo>();
      listFarmers.forEach((item) {
        if (item.firstName.toLowerCase().contains(query.toLowerCase())) {
          futureFarmers_2.add(item);
        }
      });
      setState(() {
        listFarmers.clear();
        listFarmers.addAll(futureFarmers_2);
      });
      return;
    } else {
      setState(() {
        listFarmers.clear();
        listFarmers.addAll(dummySearchList);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _apiProvider = ApiProvider();
    futureFarmers = _apiProvider.fetchFarmers(aggregatorAginID);
  }

  @override
  Widget build(BuildContext context) {
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
                            context, Icons.info, "No registered farmers yet");
                      }
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            FarmerInfo farmerdata = snapshot.data[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2.0, horizontal: 4.0),
                              child: Card(
                                child: ListTile(
                                  onTap: () {
                                    //updateTime(index);
                                    Map map = {
                                      'farmerAginID': farmerdata.userAginID,
                                      'name': farmerdata.firstName,
                                      'phone': farmerdata.phoneNumber,
                                      'aggregatorAginID': aggregatorAginID
                                    };
                                    Navigator.pushNamed(
                                        context, '/detailfarmer',
                                        arguments: map);
                                  },
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Text(
                                        '${farmerdata.firstName} ${farmerdata.lastName}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                        ),
                                      ),
                                      Text(
                                        farmerdata.phoneNumber != null
                                            ? farmerdata.phoneNumber
                                            : "",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14.0,
                                            letterSpacing: 0.5),
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
                                    child: Text(farmerdata.firstName
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
                future: futureFarmers,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          Navigator.pushNamed(context, '/newfarmer',
              arguments: {'aggregatorAginID': aggregatorAginID});
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
