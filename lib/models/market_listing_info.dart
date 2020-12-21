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

  PlaceToMarketListingInfo(
      this.cropName,
      this.pricePerUnitType,
      this.readyFromDate,
      this.quantityAvailable,
      this.producePhoto,
      this.farmerName,
      this.cultivationMode,
      this.produceStatus,
      this.unitType);

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
