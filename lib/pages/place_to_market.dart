import 'dart:io';

import 'package:AgriView/core/repository/api_repository.dart';
import 'package:AgriView/state/db_provider.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../injection.dart';
import '../models/cultivation_mode.dart';
import '../models/farm.dart';
import '../models/market_listings_meta.dart';
import '../models/produce_status.dart';
import '../models/unit_type.dart';
import '../utils/AppUtil.dart';
import 'elements/dialogs.dart';

class MarketForm extends StatefulWidget {
  final Map details;

  MarketForm({Key key, this.details}) : super(key: key);

  @override
  _MarketFormState createState() => _MarketFormState();
}

class _MarketFormState extends State<MarketForm> {
  File _image;
  final picker = ImagePicker();
  bool onFirst = true;
  bool _hasErrors = false;
  bool _isPlacingToMarket = false;
  bool unitTypeIsShown = true;
  String _quantityError, _dateError, _priceError;
  Grade _selectedGrade;
  ProduceStatus _growingStatus;
  UnitType _selectedUnitType;
  CultivationMode _selectedCultivation;

  int quantity;
  final _quantityController = TextEditingController();
  final _dateController = TextEditingController();
  final _priceController = TextEditingController();
  List<Grade> _gradeList;
  List<ProduceStatus> _statusesList;
  List<CultivationMode> _cultivationList;
  List<UnitType> _unitTypesList;

  @override
  void initState() {
    super.initState();
    _gradeList = context.read<DatabaseProvider>().grades;
    _statusesList = context.read<DatabaseProvider>().productStatus;
    _cultivationList = context.read<DatabaseProvider>().modes;
    _unitTypesList = context.read<DatabaseProvider>().unitType;
  }

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
    // Fimber.d(this.widget.details.toString());
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _imageFormWidget(),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(child: _priceFormWidget()),
                    unitTypeIsShown ? _unitTypesDropdown() : Container(),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              _quantityFormWidget(),
              SizedBox(
                height: 10,
              ),
              _dateFormWidget(),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(child: _gradeDropdown()),
                    Expanded(child: _productStatusDropdown()),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(child: _cultivationModeDropdown()),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              _submitButton()
            ],
          ),
        ),
      ),
    ));
  }

  Widget _imageFormWidget() {
    return (_image == null)
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
          );
  }

  Widget _priceFormWidget() {
    return TextField(
      controller: _priceController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          prefix: Text("Ksh "),
          suffix: (_selectedUnitType != null)
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      unitTypeIsShown != unitTypeIsShown;
                    });
                  },
                  child: Text("/${_selectedUnitType.unitTypeName}"))
              : null,
          labelText: "Price per unit type",
          errorText: (_priceError != null) ? _priceError : null),
    );
  }

  Widget _quantityFormWidget() {
    return TextField(
      controller: _quantityController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          suffix: (_selectedUnitType != null)
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      unitTypeIsShown != unitTypeIsShown;
                    });
                  },
                  child: Text("/${_selectedUnitType.unitTypeName}"))
              : null,
          labelText: "Total Quantity",
          errorText: (_quantityError != null) ? _quantityError : null),
    );
  }

  Widget _dateFormWidget() {
    return TextField(
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
    );
  }

  Widget _gradeDropdown() {
    return Container(
      child: DropdownButton<Grade>(
        hint: Text("Grade"),
        value: _selectedGrade,
        onChanged: (Grade newValue) {
          setState(() {
            _selectedGrade = newValue;
          });
        },
        items: _gradeList
            .map(
              (Grade fName) => DropdownMenuItem<Grade>(
                child: Text(fName.gradeName),
                value: fName,
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _cultivationModeDropdown() {
    return Container(
      child: DropdownButton<CultivationMode>(
        hint: Text("CultivationMode"),
        value: _selectedCultivation,
        onChanged: (CultivationMode newValue) {
          setState(() {
            _selectedCultivation = newValue;
          });
        },
        items: _cultivationList
            .map(
              (CultivationMode fName) => DropdownMenuItem<CultivationMode>(
                child: Text(fName.modeDescription),
                value: fName,
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _unitTypesDropdown() {
    return Container(
      child: DropdownButton<UnitType>(
        hint: Text("UnitType"),
        value: _selectedUnitType,
        onChanged: (UnitType newValue) {
          setState(() {
            _selectedUnitType = newValue;
            unitTypeIsShown = false;
          });
        },
        items: _unitTypesList
            .map(
              (UnitType fName) => DropdownMenuItem<UnitType>(
                child: Text(fName.unitTypeName),
                value: fName,
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _productStatusDropdown() {
    return Container(
      child: DropdownButton<ProduceStatus>(
        hint: Text("ProduceStatus"),
        value: _growingStatus,
        onChanged: (ProduceStatus newValue) {
          setState(() {
            _growingStatus = newValue;
          });
        },
        items: _statusesList
            .map(
              (ProduceStatus fName) => DropdownMenuItem<ProduceStatus>(
                child: Text(fName.statusDecription),
                value: fName,
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _submitButton() {
    return (_isPlacingToMarket)
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
          );
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
      "cultivationMode": _selectedCultivation.id,
      "produceStatus": _growingStatus.id,
      "unitType": _selectedUnitType.unitTypeID,
      "pricePerUnitType": int.parse(_priceController.text),
      "readyFromDate": _dateController.text,
      "agronomyAginID": "56df477d18574b67b311a0985964da6b",
      "quantityAvailable": int.parse(_quantityController.text),
      "phototext": await AppUtil.getFileNameWithExtension(_image),
      "photo": [await AppUtil.getImageAsBase64(_image)],
      "fileExtension": await AppUtil.getFileExtension(_image),
      "productID": 1,
      "varietyID": 1,
      "gradeID": _selectedGrade.id,
      "growingConditionID": _selectedCultivation.id
    };

    var _repository = getIt.get<ApiRepository>();

    _repository
        .placeToMarket(map)
        .then((value) => Navigator.pop(context, value))
        .catchError((err) => Future.delayed(Duration(milliseconds: 1),
            () => Dialogs.messageDialog(context, true, err.toString())));
  }
}
