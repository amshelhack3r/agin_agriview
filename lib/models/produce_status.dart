import 'dart:convert';

class ProduceStatus {
  final int id;
  final String statusDecription;

  ProduceStatus({
    this.id,
    this.statusDecription,
  });

  factory ProduceStatus.fromJson(Map<String, dynamic> json) {
    return ProduceStatus(
      id: json['id'],
      statusDecription: json['statusDecription'],
    );
  }

  ProduceStatus copyWith({
    int id,
    String statusDecription,
  }) {
    return ProduceStatus(
      id: id ?? this.id,
      statusDecription: statusDecription ?? this.statusDecription,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'statusDecription': statusDecription,
    };
  }

  factory ProduceStatus.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ProduceStatus(
      id: map['id'],
      statusDecription: map['statusDecription'],
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'ProduceStatus(id: $id, statusDecription: $statusDecription)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ProduceStatus &&
        o.id == id &&
        o.statusDecription == statusDecription;
  }

  @override
  int get hashCode => id.hashCode ^ statusDecription.hashCode;
}
