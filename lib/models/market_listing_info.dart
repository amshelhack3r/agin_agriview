import 'dart:convert';

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
  PlaceToMarketListingInfo({
    this.cropName,
    this.pricePerUnitType,
    this.readyFromDate,
    this.quantityAvailable,
    this.producePhoto,
    this.farmerName,
    this.cultivationMode,
    this.produceStatus,
    this.unitType,
  });

  PlaceToMarketListingInfo copyWith({
    String cropName,
    String pricePerUnitType,
    String readyFromDate,
    int quantityAvailable,
    String producePhoto,
    String farmerName,
    String cultivationMode,
    String produceStatus,
    String unitType,
  }) {
    return PlaceToMarketListingInfo(
      cropName: cropName ?? this.cropName,
      pricePerUnitType: pricePerUnitType ?? this.pricePerUnitType,
      readyFromDate: readyFromDate ?? this.readyFromDate,
      quantityAvailable: quantityAvailable ?? this.quantityAvailable,
      producePhoto: producePhoto ?? this.producePhoto,
      farmerName: farmerName ?? this.farmerName,
      cultivationMode: cultivationMode ?? this.cultivationMode,
      produceStatus: produceStatus ?? this.produceStatus,
      unitType: unitType ?? this.unitType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cropName': cropName,
      'pricePerUnitType': pricePerUnitType,
      'readyFromDate': readyFromDate,
      'quantityAvailable': quantityAvailable,
      'producePhoto': producePhoto,
      'farmerName': farmerName,
      'cultivationMode': cultivationMode,
      'produceStatus': produceStatus,
      'unitType': unitType,
    };
  }

  factory PlaceToMarketListingInfo.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return PlaceToMarketListingInfo(
      cropName: map['cropName'],
      pricePerUnitType: map['pricePerUnitType'],
      readyFromDate: map['readyFromDate'],
      quantityAvailable: map['quantityAvailable'],
      producePhoto: map['producePhoto'],
      farmerName: map['farmerName'],
      cultivationMode: map['cultivationMode'],
      produceStatus: map['produceStatus'],
      unitType: map['unitType'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PlaceToMarketListingInfo.fromJson(String source) =>
      PlaceToMarketListingInfo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PlaceToMarketListingInfo(cropName: $cropName, pricePerUnitType: $pricePerUnitType, readyFromDate: $readyFromDate, quantityAvailable: $quantityAvailable, producePhoto: $producePhoto, farmerName: $farmerName, cultivationMode: $cultivationMode, produceStatus: $produceStatus, unitType: $unitType)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is PlaceToMarketListingInfo &&
        o.cropName == cropName &&
        o.pricePerUnitType == pricePerUnitType &&
        o.readyFromDate == readyFromDate &&
        o.quantityAvailable == quantityAvailable &&
        o.producePhoto == producePhoto &&
        o.farmerName == farmerName &&
        o.cultivationMode == cultivationMode &&
        o.produceStatus == produceStatus &&
        o.unitType == unitType;
  }

  @override
  int get hashCode {
    return cropName.hashCode ^
        pricePerUnitType.hashCode ^
        readyFromDate.hashCode ^
        quantityAvailable.hashCode ^
        producePhoto.hashCode ^
        farmerName.hashCode ^
        cultivationMode.hashCode ^
        produceStatus.hashCode ^
        unitType.hashCode;
  }
}
