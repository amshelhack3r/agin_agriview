import 'dart:convert';

class Farm {
  String farmName;
  String farmLocation;
  String currentLandUse;
  String producerAginId;
  String lat;
  String lon;
  int acreageMapped;
  int acreageApproved;
  Farm({
    this.farmName,
    this.farmLocation,
    this.currentLandUse,
    this.producerAginId,
    this.lat,
    this.lon,
    this.acreageMapped,
    this.acreageApproved,
  });

  Farm copyWith({
    String farmName,
    String farmLocation,
    String currentLandUse,
    String producerAginId,
    String lat,
    String lon,
    int acreageMapped,
    int acreageApproved,
  }) {
    return Farm(
      farmName: farmName ?? this.farmName,
      farmLocation: farmLocation ?? this.farmLocation,
      currentLandUse: currentLandUse ?? this.currentLandUse,
      producerAginId: producerAginId ?? this.producerAginId,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      acreageMapped: acreageMapped ?? this.acreageMapped,
      acreageApproved: acreageApproved ?? this.acreageApproved,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'farmName': farmName,
      'farmLocation': farmLocation,
      'currentLandUse': currentLandUse,
      'producerAginId': producerAginId,
      'lat': lat,
      'lon': lon,
      'acreageMapped': acreageMapped,
      'acreageApproved': acreageApproved,
    };
  }

  factory Farm.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Farm(
      farmName: map['farmName'],
      farmLocation: map['farmLocation'],
      currentLandUse: map['currentLandUse'],
      producerAginId: map['producerAginId'],
      lat: map['lat'],
      lon: map['lon'],
      acreageMapped: map['acreageMapped'],
      acreageApproved: map['acreageApproved'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Farm.fromJson(String source) => Farm.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Farm(farmName: $farmName, farmLocation: $farmLocation, currentLandUse: $currentLandUse, producerAginId: $producerAginId, lat: $lat, lon: $lon, acreageMapped: $acreageMapped, acreageApproved: $acreageApproved)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Farm &&
        o.farmName == farmName &&
        o.farmLocation == farmLocation &&
        o.currentLandUse == currentLandUse &&
        o.producerAginId == producerAginId &&
        o.lat == lat &&
        o.lon == lon &&
        o.acreageMapped == acreageMapped &&
        o.acreageApproved == acreageApproved;
  }

  @override
  int get hashCode {
    return farmName.hashCode ^
        farmLocation.hashCode ^
        currentLandUse.hashCode ^
        producerAginId.hashCode ^
        lat.hashCode ^
        lon.hashCode ^
        acreageMapped.hashCode ^
        acreageApproved.hashCode;
  }
}
