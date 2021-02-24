import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';

import '../core/repository/api_repository.dart';
import '../injection.dart';
import '../models/dropdownform.dart';
import '../models/farm.dart';
import '../models/product.dart';
import '../utils/AppUtil.dart';
import 'elements/dialogs.dart';

class ProducePage extends StatefulWidget {
  final Map<String, dynamic> detail;
  ProducePage(this.detail, {Key key}) : super(key: key);

  @override
  _ProducePageState createState() => _ProducePageState();
}

class _ProducePageState extends State<ProducePage> {
  Farm farm;
  GlobalKey _scaffoldState = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    setState(() {
      farm = widget.detail['farm'];
    });

    return Scaffold(
        key: _scaffoldState,
        appBar: AppBar(),
        body: Builder(builder: (BuildContext ctx) {
          return Container(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                _buildFirstCard(),
                SizedBox(
                  height: 10,
                ),
                _buildSecondCard(ctx),
                SizedBox(
                  height: 10,
                ),
                _buildProduce()
              ],
            ),
          );
        }));
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

  _buildSecondCard(BuildContext myContext) {
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
                  GestureDetector(
                    onTap: () {
                      Scaffold.of(myContext).showBottomSheet(
                        (context) => Container(
                          height: MediaQuery.of(context).size.width,
                          width: double.infinity,
                          child: FutureBuilder(
                            future: getIt.get<ApiRepository>().fetchProduce(),
                            builder: (context,
                                AsyncSnapshot<List<Product>> snapshot) {
                              if (snapshot.hasData) {
                                var data = snapshot.data;
                                return Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: ListView.builder(
                                    itemCount: data.length,
                                    itemBuilder: (context, index) {
                                      Product p = data[index];
                                      return ListTile(
                                        leading: Image.network(
                                          p.fileName,
                                          width: 50,
                                          height: 50,
                                        ),
                                        title: Text(p.productName),
                                        trailing: ElevatedButton(
                                          child: Text("add"),
                                          onPressed: () => addProduce(p),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                Future.delayed(
                                    Duration(milliseconds: 1),
                                    () => Dialogs.messageDialog(context, true,
                                        snapshot.error.toString()));
                                return Container();
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Image.asset("assets/images/market.png", width: 40),
                        Text(
                          "Add Produce",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 12),
                        ),
                      ],
                    ),
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
      content: PlaceToMarketListing(this.widget.detail),
    );
  }

  void addProduce(Product p) {
    Farm f = widget.detail['farm'];
    var _repository = getIt.get<ApiRepository>();
    Map params = {"landAginID": f.landAginId, "productUUID": p.uuid};
    _repository
        .addProduce(params)
        .then((value) => Navigator.pop(context))
        .catchError((err) => {
              Future.delayed(Duration(milliseconds: 1),
                  () => Dialogs.messageDialog(context, true, err.toString()))
            });
  }
}

class PlaceToMarketListing extends StatefulWidget {
  final Map details;
  const PlaceToMarketListing(this.details);
  @override
  _PlaceToMarketListingState createState() => _PlaceToMarketListingState();
}

class _PlaceToMarketListingState extends State<PlaceToMarketListing> {
  File _image;
  final picker = ImagePicker();
  bool onFirst = true;
  bool _hasErrors = false;
  bool _isPlacingToMarket = false;
  String _selectedDate,
      _grade,
      _growingStatus,
      _location,
      _status,
      _quantityError,
      _dateError;
  int quantity;
  final _quantityController = TextEditingController();
  final _dateController = TextEditingController();

  final grade = [
    FieldName("grade 1"),
    FieldName("grade 2"),
    FieldName("grade 3"),
    FieldName("mixed")
  ];

  final growingStatus = [
    FieldName("Open Field"),
    FieldName("Green House"),
    FieldName("Shadenet")
  ];

  final productLocation = [FieldName("Farm"), FieldName("Bundling Center")];

  final productStatus = [
    FieldName("Ready for Harvest"),
    FieldName("Harvested")
  ];

  FieldName _selectedGrade, _selectedGrowingStatus, _selectedProduceLocation;

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
    print(widget.details);
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
                width: 100,
                height: 100,
              ),
        TextField(
          controller: _quantityController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              labelText: "Quantity",
              errorText: (_quantityError != null) ? _quantityError : null),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          enabled: true,
          controller: _dateController,
          decoration: InputDecoration(
            errorText: (_dateError != null) ? _dateError : null,
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
              _dateController.text = AppUtil.formatDate(date);
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
                onFirst = !onFirst;
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
            child: DropdownButton<FieldName>(
              hint: Text("Grade"),
              value: _selectedGrade,
              onChanged: (FieldName newValue) {
                setState(() {
                  _selectedGrade = newValue;
                });
              },
              items: grade
                  .map(
                    (FieldName fName) => DropdownMenuItem<FieldName>(
                      child: Text(fName.name),
                      value: fName,
                    ),
                  )
                  .toList(),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: DropdownButton<FieldName>(
              hint: Text("Growing Status"),
              value: _selectedGrowingStatus,
              onChanged: (FieldName newValue) {
                setState(() {
                  _selectedGrowingStatus = newValue;
                });
              },
              items: growingStatus
                  .map(
                    (FieldName fName) => DropdownMenuItem<FieldName>(
                      child: Text(fName.name),
                      value: fName,
                    ),
                  )
                  .toList(),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: DropdownButton<FieldName>(
              hint: Text("Location"),
              value: _selectedProduceLocation,
              onChanged: (FieldName newValue) {
                setState(() {
                  _selectedProduceLocation = newValue;
                });
              },
              items: productLocation
                  .map(
                    (FieldName fName) => DropdownMenuItem<FieldName>(
                      child: Text(fName.name),
                      value: fName,
                    ),
                  )
                  .toList(),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  icon: Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      onFirst = !onFirst;
                    });
                  }),
              (_isPlacingToMarket)
                  ? RaisedButton(
                      color: Colors.white,
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : RaisedButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: () => _submitForm(),
                      child: Text('submit'),
                    ),
            ],
          ),
        ]);
  }

  _submitForm() async {
    //validate forms
    if (_image == null) {}

    //validate quantity
    if (_quantityController.text.isEmpty) {
      setState(() {
        _quantityError = "quantity is required";
        _hasErrors = true;
      });
    }

    if (int.parse(_quantityController.text) < 1) {
      setState(() {
        _quantityError = "quantity cannot be zero";
        _hasErrors = true;
      });
    }

    if (_dateController.text.isEmpty) {
      setState(() {
        _dateError = "date is required";
        _hasErrors = true;
      });
    }

    setState(() {
      _isPlacingToMarket = true;
    });
    //compare dates
    Farm farm = widget.details['farm'] as Farm;
    var producerAginID = widget.details['producerAginId'];
    var map = {
      "farmerAginID": producerAginID,
      "landAginID": farm.landAginId,
      "cultivationMode": 1,
      "produceStatus": 1,
      "unitType": 1,
      "pricePerUnitType": 500,
      "readyFromDate": "2020-03-01",
      "agronomyAginID": "56df477d18574b67b311a0985964da6b",
      "quantityAvailable": 20,
      "phototext": AppUtil.getFileNameWithExtension(_image),
      "photo": [AppUtil.getImageAsBase64(_image)],
      "fileExtension": AppUtil.getFileExtension(_image),
      "productID": 1,
      "varietyID": 1,
      "gradeID": 1,
      "growingConditionID": 1
    };

    var _repository = getIt.get<ApiRepository>();

    _repository
        .placeToMarket(map)
        .then((value) => Navigator.pop(context))
        .catchError((err) => Future.delayed(Duration(milliseconds: 1),
            () => Dialogs.messageDialog(context, true, err.toString())));
  }

  Widget _generateDropdown(
      String hint, FieldName _selectedField, List<FieldName> fields) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton<FieldName>(
        hint: Text(hint),
        value: _selectedField,
        onChanged: (FieldName newValue) {
          setState(() {
            _selectedField = newValue;
          });
        },
        items: fields
            .map(
              (FieldName fName) => DropdownMenuItem<FieldName>(
                child: Text(fName.name),
                value: fName,
              ),
            )
            .toList(),
      ),
    );
  }
}
