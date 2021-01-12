import 'dart:convert';

class Country {
  final int id;
  final String name;
  Country({
    this.id,
    this.name,
  });

  Country copyWith({
    int id,
    String name,
  }) {
    return Country(
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

  factory Country.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Country(
      id: map['id'],
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Country.fromJson(String source) =>
      Country.fromMap(json.decode(source));

  @override
  String toString() => 'Country(id: $id, name: $name)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Country && o.id == id && o.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
