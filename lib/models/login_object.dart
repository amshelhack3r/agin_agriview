import 'dart:convert';

class AggregatorLoginObject {
  final String youthAGINID;
  final String firstName;
  final String lastName;

  AggregatorLoginObject(
    this.youthAGINID,
    this.firstName,
    this.lastName,
  );

  AggregatorLoginObject copyWith({
    String youthAGINID,
    String firstName,
    String lastName,
  }) {
    return AggregatorLoginObject(
      youthAGINID ?? this.youthAGINID,
      firstName ?? this.firstName,
      lastName ?? this.lastName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'youthAGINID': youthAGINID,
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  factory AggregatorLoginObject.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return AggregatorLoginObject(
      map['youthAGINID'],
      map['firstName'],
      map['lastName'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AggregatorLoginObject.fromJson(String source) =>
      AggregatorLoginObject.fromMap(json.decode(source));

  @override
  String toString() =>
      'AggregatorLoginObject(youthAGINID: $youthAGINID, firstName: $firstName, lastName: $lastName)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is AggregatorLoginObject &&
        o.youthAGINID == youthAGINID &&
        o.firstName == firstName &&
        o.lastName == lastName;
  }

  @override
  int get hashCode =>
      youthAGINID.hashCode ^ firstName.hashCode ^ lastName.hashCode;
}
