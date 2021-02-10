import 'package:flutter/material.dart';

import '../core/repository/api_repository.dart';
import '../injection.dart';
import '../models/farm.dart';
import '../models/farmer_info.dart';
import 'elements/dialogs.dart';

class FarmerDashboard extends StatefulWidget {
  final FarmerInfo farmer;
  const FarmerDashboard(this.farmer, {Key key}) : super(key: key);

  @override
  _FarmerInfoState createState() => _FarmerInfoState();
}

class _FarmerInfoState extends State<FarmerDashboard> {
  int farms = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Farmer Dashboard"),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Container(
            height: 100,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset(
                  "assets/images/dashboard_mask.png",
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
                Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            "FARMER DETAILS",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          _buildFirstCard(),
          SizedBox(
            height: 10,
          ),
          Text(
            "FARMS",
            style:
                TextStyle(fontSize: 12, decoration: TextDecoration.underline),
          ),
          SizedBox(
            height: 10,
          ),
          FutureBuilder(
            future:
                getIt.get<ApiRepository>().fetchFarm(widget.farmer.userAginID),
            builder: (context, AsyncSnapshot<List<Farm>> snapshot) {
              if (snapshot.hasData) {
                List<Farm> farmsList = snapshot.data;
                if (farmsList.length == 0) {
                  return _noFarms();
                } else {
                  return Expanded(
                    child: ListView.separated(
                      itemCount: farmsList.length,
                      separatorBuilder: (context, int) => Divider(),
                      itemBuilder: (context, index) {
                        Farm info = farmsList[index];
                        return _farmListItem(info);
                      },
                    ),
                  );
                }
              } else if (snapshot.hasError) {
                print(snapshot.error);
                Dialogs.messageDialog(context, true, snapshot.error.toString());
                return Container();
              } else {
                return Expanded(
                    child: Center(
                  child: CircularProgressIndicator(),
                ));
              }
            },
          )
        ],
      )),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.add),
          onPressed: () => Navigator.pushNamed(
                context,
                '/AddFarmPage',
                arguments: widget.farmer,
              )),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  _buildFirstCard() {
    FarmerInfo fm = widget.farmer;
    TextStyle subText = TextStyle(
      color: Colors.black,
      fontSize: 10,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    alignment: Alignment.center,
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Text(
                      widget.farmer.initials,
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    )),
                Text(
                  fm.fullname,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
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
                      Text("Phone Number"),
                      Text(
                        fm.phoneNumber,
                        style: subText,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text("status"),
                      Text(
                        "active",
                        style: subText,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text("registered"),
                      Text(
                        fm.createdat,
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

  _noFarms() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/farms.png"),
            SizedBox(
              height: 10,
            ),
            Text(
              "No Farms",
              style: TextStyle(color: Colors.blueGrey, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () => Navigator.pushNamed(context, '/AddFarmPage',
                  arguments: widget.farmer),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                child: Text("ADD NEW"),
              ),
            )
          ],
        ),
      ),
    );
  }

  _farmListItem(Farm farm) {
    Map<String, dynamic> params = {
      "farm": farm,
      "producerAginId": widget.farmer.userAginID
    };

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/ProducePage',
        arguments: params,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/farms.png",
                  width: 40,
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      farm.farmName,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      farm.farmLocation,
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Spacer(),
                Icon(Icons.chevron_right),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
