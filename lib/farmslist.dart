import 'dart:math';
import 'package:flutter/material.dart';
import 'package:AgriView/world_time.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:AgriView/utils/constants.dart';
import 'dart:convert';

Future <List<FarmInfo>> fetchFarms(String farmerAginID) async {
  final response =
  await http.post(Uri.parse('${serverURL}producer/farms'),
    headers: <String, String>{
      'X-AGIN-API-Key-Token': APIKEY,
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'AginID' : farmerAginID,
    }),

  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    List<FarmInfo> listFarms = items.map<FarmInfo>((json) {
      return FarmInfo.fromJson(json);
    }).toList();

    return listFarms;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load farmers');
  }
}

class FarmInfo {
  final String landAginId;
  final String farmName;
  final String farmLocation;
  final int acreageMapped;
  final int acreageApproved;

  FarmInfo({this.landAginId, this.farmName, this.farmLocation, this.acreageMapped, this.acreageApproved});

  factory FarmInfo.fromJson(Map<String, dynamic> json) {
    return FarmInfo(
      landAginId : json['landAginId'],
      farmName : json['farmName'],
      farmLocation : json['farmLocation'],
      acreageMapped : json['acreageMapped'],
      acreageApproved :  json['acreageApproved'],

    );
  }
}

class FarmsList extends StatefulWidget {
  @override
  _FarmsListState createState() => _FarmsListState();
}

class _FarmsListState extends State<FarmsList> {

  @override
  Widget build(BuildContext context) {

    Map data = {};
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    String name = data['name'].toString().split(" ")[0];
    String farmerAginID = data['farmerAginID'].toString();
    String aggregatorAginID = data['aggregatorAginID'].toString();

    Color colorCode = Theme.of(context).primaryColor;

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
      appBar: AppBar(
        title: Text('$name Farms List'),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder(
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              print('hasdata${snapshot.hasData}');
      return ListView.builder(
        itemCount: snapshot.data != null ? snapshot.data.length : 0,
        itemBuilder: (context,index){
          FarmInfo farmInfo = snapshot.data[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
            child: Card(
              child: ListTile(
                onTap: (){
                  //updateTime(index);
                  Map map = {'farmerAginID':farmerAginID, 'landAginID':farmInfo.landAginId, 'farm_name' : farmInfo.farmName, 'farm_location' : farmInfo.farmLocation, 'acreage_mapped' : farmInfo.acreageMapped, 'acreage_approved' : farmInfo.acreageApproved, 'aggregatorAginID' : aggregatorAginID};
                  Navigator.pushNamed(context, '/detailfarm',arguments: map);
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
                          letterSpacing: 0.5
                      ),
                    ),
                  ],
                ),
                leading: CircleAvatar(
                  backgroundColor: colorCode,
                  child: Text(
                      ""
                  ),
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
    future: fetchFarms(farmerAginID),
    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          Navigator.pushNamed(context, '/newfarm', arguments: {'farmerAginID':farmerAginID});
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
