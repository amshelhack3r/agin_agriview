import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// import 'package:url_launcher/url_launcher.dart';

import '../core/repository/api_repository.dart';
import '../injection.dart';
import '../models/farmer_info.dart';
import '../state/user_provider.dart';
import '../utils/hex_color.dart';
import 'elements/dialogs.dart';

class FarmersListPage extends StatelessWidget {
  FarmersListPage({Key key}) : super(key: key);
  var width;
  var primaryColor;

  @override
  Widget build(BuildContext context) {
    var aginId = context.watch<UserProvider>().aginId;
    width = MediaQuery.of(context).size.width;
    primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: Text("Farmers List"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            FutureBuilder(
                future: getIt.get<ApiRepository>().fetchFarmers(aginId),
                builder: (context, AsyncSnapshot<List<FarmerInfo>> snapshot) {
                  if (snapshot.hasData) {
                    var farmers = snapshot.data;
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ActionChip(
                                  backgroundColor: primaryColor,
                                  label: Text(
                                    "${snapshot.data.length.toString()} Farmers",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                  onPressed: () {}),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      hintText: "search farmer",
                                      labelText: "search"),
                                ),
                              )
                            ],
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: farmers.length,
                          itemBuilder: (context, index) {
                            FarmerInfo farmer = farmers[index];
                            return _buildListItem(context, farmer);
                          },
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    Fimber.d(snapshot.error.toString());
                    Future.delayed(
                        Duration(milliseconds: 1),
                        () => Dialogs.messageDialog(
                            context, true, snapshot.error.toString()));
                    return Container();
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
          ],
        ),
      ),
    );
  }

  _buildHeader() {
    var oneThird = width / 6;
    return Container(
      width: width,
      height: 50,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Image.asset(
            "assets/images/dashboard_mask.png",
            width: width,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: -40,
            left: oneThird / 2,
            right: oneThird / 2,
            child: SizedBox(
              width: oneThird * 2,
              child: TextField(
                // style: TextStyle(color: Colors.amber),
                decoration: InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                    hintText: "Search",
                    hintStyle: TextStyle(color: Colors.black)),
              ),
            ),
          )
        ],
      ),
    );
  }

  _buildListItem(BuildContext context, FarmerInfo farmer) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, "/FarmerInfo", arguments: farmer),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: HexColor("#8E8E8E"),
                blurRadius: 1.0,
                spreadRadius: 0.0,
                offset: Offset(2.0, 2.0), // shadow direction: bottom right
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(farmer.initials,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: Colors.white)),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(farmer.fullname,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: HexColor("#8E8E8E"))),
                    Text(
                      farmer.phoneNumber,
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
                Spacer(),
                IconButton(
                    icon: Icon(Icons.call),
                    onPressed: () => _makeCall(farmer.phoneNumber))
                // Column()
              ],
            ),
          ),
        ),
      ),
    );
  }

  _makeCall(String mobile) async {
    var url = "tel:$mobile";

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not laounch $url';
    }
  }
}
