import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'api/api_provider.dart';

class FarmsList extends StatefulWidget {
  @override
  _FarmsListState createState() => _FarmsListState();
}

class _FarmsListState extends State<FarmsList> {
  ApiProvider _apiProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiProvider = ApiProvider();
  }

  @override
  Widget build(BuildContext context) {
    Map data = {};
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    String name = data['name'].toString().split(" ")[0];
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

    generateRandomColor();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('$name Farms List'),
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
              return ListView.builder(
                itemCount: snapshot.data != null ? snapshot.data.length : 0,
                itemBuilder: (context, index) {
                  var farmInfo = snapshot.data[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 2.0, horizontal: 4.0),
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          //updateTime(index);
                          Map map = {
                            'farmerAginID': farmerAginID,
                            'landAginID': farmInfo.landAginId,
                            'farm_name': farmInfo.farmName,
                            'farm_location': farmInfo.farmLocation,
                            'acreage_mapped': farmInfo.acreageMapped,
                            'acreage_approved': farmInfo.acreageApproved,
                            'aggregatorAginID': aggregatorAginID
                          };
                          Navigator.pushNamed(context, '/detailfarm',
                              arguments: map);
                        },
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(
                              farmInfo.farmName,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.0,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              farmInfo.farmLocation,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.0,
                                  letterSpacing: 0.5),
                            ),
                          ],
                        ),
                        leading: CircleAvatar(
                          backgroundColor: colorCode,
                          child: Text(""),
                          //backgroundImage: AssetImage('assets/${locations[index].flag}'),
                        ),
                        trailing: Icon(
                          Icons.navigate_next,
                          //backgroundImage: AssetImage('assets/${locations[index].flag}'),
                        ),
                        //trailing: Visibility(
                        //visible: !maybe,

                        // ),
                      ),
                    ),
                  );
                },
              );

            default:
              return CircularProgressIndicator();
          }
        },
        future: _apiProvider.fetchFarmers(farmerAginID),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          Navigator.pushNamed(context, '/newfarm',
              arguments: {'farmerAginID': farmerAginID});
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
