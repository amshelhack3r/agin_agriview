import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';

import '../core/repository/api_repository.dart';
import '../injection.dart';
import '../models/farm.dart';
import 'elements/dialogs.dart';

class ProducePage extends StatefulWidget {
  final Map<String, dynamic> detail;
  ProducePage(this.detail, {Key key}) : super(key: key);

  @override
  _ProducePageState createState() => _ProducePageState();
}

class _ProducePageState extends State<ProducePage> {
  Farm farm;
  @override
  Widget build(BuildContext context) {
    setState(() {
      farm = widget.detail['farm'];
    });

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            _buildFirstCard(),
            SizedBox(
              height: 10,
            ),
            _buildSecondCard(),
            SizedBox(
              height: 10,
            ),
            _buildProduce()
          ],
        ),
      ),
    );
  }

  _buildFirstCard() {
    TextStyle subText = TextStyle(
      color: Colors.black,
      fontSize: 12,
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
            Text(
              farm.farmName,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              farm.farmLocation,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w400,
              ),
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
                      Text('usage'),
                      Text(
                        farm.currentLandUse,
                        style: subText,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Mapped"),
                      Text(
                        "${farm.acreageMapped.toString()} acres",
                        style: subText,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text("approved"),
                      Text(
                        "${farm.acreageApproved.toString()} acres",
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

  _buildSecondCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: Text(
                "Actions",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
                      Image.asset("assets/images/visit.png", width: 40),
                      Text(
                        "Scout Land",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset("assets/images/report.png", width: 40),
                      Text(
                        "Advise",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset("assets/images/market.png", width: 40),
                      Text(
                        "Add Produce",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 12),
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

  _buildProduce() {
    return Expanded(
      child: FutureBuilder(
        future: getIt.get<ApiRepository>().fetchLandProduce(farm.landAginId),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return Wrap(
                children: [
                  ...snapshot.data.map((produce) {
                    return Container(
                      child: Column(
                        children: [
                          CachedNetworkImage(
                            imageUrl: produce['fileName'],
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Center(
                              child: CircularProgressIndicator(
                                  value: downloadProgress.progress),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(produce['name']),
                          SizedBox(
                            height: 10,
                          ),
                          RaisedButton(
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            onPressed: () => showDialog(
                                context: context,
                                builder: (_) => _placeToMarketAlert()),
                            child: Text('market'),
                          )
                        ],
                      ),
                    );
                  })
                ],
              );
            } else {
              return Center(
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: () => {},
                  child: Text("ADD PRODUCE"),
                ),
              );
            }
          } else if (snapshot.hasError) {
            Dialogs.messageDialog(context, true, snapshot.error.toString());
            return Container();
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  AlertDialog _placeToMarketAlert() {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      contentPadding: EdgeInsets.all(20.0),
      backgroundColor: Theme.of(context).canvasColor,
      title: Container(
        alignment: Alignment.center,
        child: Text(
          "Place to Market",
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      content: PlaceToMarketListing(),
    );
  }
}

class PlaceToMarketListing extends StatefulWidget {
  @override
  _PlaceToMarketListingState createState() => _PlaceToMarketListingState();
}

class _PlaceToMarketListingState extends State<PlaceToMarketListing> {
  File _image;
  final picker = ImagePicker();
  bool onFirst = true;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: onFirst ? _firstPage() : _secondPage());
  }

  _firstPage() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        (_image == null)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("upload photo"),
                  RaisedButton(
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () => getImage(),
                    child: Text("photo"),
                  )
                ],
              )
            : Image.file(
                _image,
                width: 150,
                height: 150,
              ),
        TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: "Quantity",
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          decoration: InputDecoration(
            labelText: "date ready",
          ),
          onTap: () {
            DatePicker.showDatePicker(context,
                showTitleActions: true,
                minTime: DateTime(2018, 3, 5),
                maxTime: DateTime(2019, 6, 7), onChanged: (date) {
              print('change $date');
            }, onConfirm: (date) {
              print('confirm $date');
            }, currentTime: DateTime.now(), locale: LocaleType.en);
          },
        ),
        SizedBox(
          height: 10,
        ),
        IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed: () {
              setState(() {
                onFirst = false;
              });
            })
      ],
    );
  }

  _secondPage() {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: DropdownButton(
                hint: Text("Grade"),
                onChanged: (int value) {},
                items: [
                  DropdownMenuItem(
                    onTap: () {},
                    child: Text("Grade 1"),
                    value: 1,
                  ),
                  DropdownMenuItem(
                    onTap: () {},
                    child: Text("Grade 2"),
                    value: 2,
                  ),
                  DropdownMenuItem(
                    onTap: () {},
                    child: Text("Grade 3"),
                    value: 3,
                  ),
                  DropdownMenuItem(
                    onTap: () {},
                    child: Text("mixed"),
                    value: 4,
                  ),
                ]),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: DropdownButton(
                hint: Text("Growing Status"),
                onChanged: (int value) {},
                items: [
                  DropdownMenuItem(
                    onTap: () {},
                    child: Text("Open Field"),
                    value: 1,
                  ),
                  DropdownMenuItem(
                    onTap: () {},
                    child: Text("Green house"),
                    value: 2,
                  ),
                  DropdownMenuItem(
                    onTap: () {},
                    child: Text("SHadenet"),
                    value: 3,
                  ),
                ]),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: DropdownButton(
                hint: Text("Location"),
                onChanged: (int value) {},
                items: [
                  DropdownMenuItem(
                    onTap: () {},
                    child: Text("Farmer"),
                    value: 1,
                  ),
                  DropdownMenuItem(
                    onTap: () {},
                    child: Text("Bundling Center"),
                    value: 2,
                  ),
                ]),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: DropdownButton(
                hint: Text("Status"),
                onChanged: (int value) {},
                items: [
                  DropdownMenuItem(
                    onTap: () {},
                    child: Text("Ready for harvest"),
                    value: 1,
                  ),
                  DropdownMenuItem(
                    onTap: () {},
                    child: Text("Harvested"),
                    value: 2,
                  ),
                ]),
          ),
          SizedBox(
            height: 10,
          ),
          RaisedButton(
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: () {},
            child: Text('submit'),
          ),
        ]);
  }
}
