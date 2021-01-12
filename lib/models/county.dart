import 'dart:convert';

class County {
  int countyID;
  String countyName;
  County({
    this.countyID,
    this.countyName,
  });

  County copyWith({
    int countyID,
    String countyName,
  }) {
    return County(
      countyID: countyID ?? this.countyID,
      countyName: countyName ?? this.countyName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'countyID': countyID,
      'countyName': countyName,
    };
  }

  factory County.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return County(
      countyID: map['countyID'],
      countyName: map['countyName'],
    );
  }

  String toJson() => json.encode(toMap());

  factory County.fromJson(String source) => County.fromMap(json.decode(source));

  @override
  String toString() => 'County(countyID: $countyID, countyName: $countyName)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is County && o.countyID == countyID && o.countyName == countyName;
  }

  @override
  int get hashCode => countyID.hashCode ^ countyName.hashCode;
}
