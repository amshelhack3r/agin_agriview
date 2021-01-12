import 'dart:convert';

class CultivationMode {
  final int id;
  final String modeDescription;
  CultivationMode({
    this.id,
    this.modeDescription,
  });

  CultivationMode copyWith({
    int id,
    String modeDescription,
  }) {
    return CultivationMode(
      id: id ?? this.id,
      modeDescription: modeDescription ?? this.modeDescription,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'modeDescription': modeDescription,
    };
  }

  factory CultivationMode.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return CultivationMode(
      id: map['id'],
      modeDescription: map['modeDescription'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CultivationMode.fromJson(String source) =>
      CultivationMode.fromMap(json.decode(source));

  @override
  String toString() =>
      'CultivationMode(id: $id, modeDescription: $modeDescription)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is CultivationMode &&
        o.id == id &&
        o.modeDescription == modeDescription;
  }

  @override
  int get hashCode => id.hashCode ^ modeDescription.hashCode;
}
