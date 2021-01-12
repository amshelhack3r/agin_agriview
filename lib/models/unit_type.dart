import 'dart:convert';

class UnitType {
  final int unitTypeID;
  final String unitTypeName;
  UnitType({
    this.unitTypeID,
    this.unitTypeName,
  });

  UnitType copyWith({
    int unitTypeID,
    String unitTypeName,
  }) {
    return UnitType(
      unitTypeID: unitTypeID ?? this.unitTypeID,
      unitTypeName: unitTypeName ?? this.unitTypeName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'unitTypeID': unitTypeID,
      'unitTypeName': unitTypeName,
    };
  }

  factory UnitType.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return UnitType(
      unitTypeID: map['unitTypeID'],
      unitTypeName: map['unitTypeName'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UnitType.fromJson(String source) =>
      UnitType.fromMap(json.decode(source));

  @override
  String toString() =>
      'UnitType(unitTypeID: $unitTypeID, unitTypeName: $unitTypeName)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is UnitType &&
        o.unitTypeID == unitTypeID &&
        o.unitTypeName == unitTypeName;
  }

  @override
  int get hashCode => unitTypeID.hashCode ^ unitTypeName.hashCode;
}
