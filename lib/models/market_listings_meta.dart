import 'dart:convert';

import 'produce_status.dart';

class Grade {
  int id;
  String gradeName;
  Grade({
    this.id,
    this.gradeName,
  });

  Grade copyWith({
    int id,
    String gradeName,
  }) {
    return Grade(
      id: id ?? this.id,
      gradeName: gradeName ?? this.gradeName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'gradeName': gradeName,
    };
  }

  factory Grade.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Grade(
      id: map['id'],
      gradeName: map['gradeName'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Grade.fromJson(String source) => Grade.fromMap(json.decode(source));

  @override
  String toString() => 'Grade(id: $id, gradeName: $gradeName)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Grade && o.id == id && o.gradeName == gradeName;
  }

  @override
  int get hashCode => id.hashCode ^ gradeName.hashCode;
}

class Variety {
  int id;
  String name;
  Variety({
    this.id,
    this.name,
  });

  Variety copyWith({
    int id,
    String name,
  }) {
    return Variety(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Variety.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Variety(
      id: map['id'],
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Variety.fromJson(String source) =>
      Variety.fromMap(json.decode(source));

  @override
  String toString() => 'Variety(id: $id, name: $name)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Variety && o.id == id && o.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}

class GrowingStatus extends ProduceStatus {}
