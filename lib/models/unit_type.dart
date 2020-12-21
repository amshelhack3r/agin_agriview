class UnitType {
  final int unitTypeID;
  final String unitTypeName;

  UnitType({this.unitTypeID, this.unitTypeName});

  factory UnitType.fromJson(Map<String, dynamic> json) {
    return UnitType(
      unitTypeID: json['unitTypeID'],
      unitTypeName: json['unitTypeName'],
    );
  }
}
