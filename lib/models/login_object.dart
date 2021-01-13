import 'dart:convert';

class AggregatorLoginObject {
  final String youthAGINID;
  final String firstName;
  final String lastName;
  final String phoneNumber;

  AggregatorLoginObject(
    this.youthAGINID,
    this.firstName,
    this.lastName,
    this.phoneNumber,
  );

  String get fullName => "$firstName $lastName";

  AggregatorLoginObject copyWith({
    String youthAGINID,
    String firstName,
    String lastName,
    String phoneNumber,
  }) {
    return AggregatorLoginObject(
      youthAGINID ?? this.youthAGINID,
      firstName ?? this.firstName,
      lastName ?? this.lastName,
      phoneNumber ?? this.phoneNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'youthAGINID': youthAGINID,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
    };
  }

  factory AggregatorLoginObject.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return AggregatorLoginObject(
      map['youthAGINID'],
      map['firstName'],
      map['lastName'],
      map['phoneNumber'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AggregatorLoginObject.fromJson(String source) =>
      AggregatorLoginObject.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AggregatorLoginObject(youthAGINID: $youthAGINID, firstName: $firstName, lastName: $lastName, phoneNumber: $phoneNumber)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is AggregatorLoginObject &&
        o.youthAGINID == youthAGINID &&
        o.firstName == firstName &&
        o.lastName == lastName &&
        o.phoneNumber == phoneNumber;
  }

  @override
  int get hashCode {
    return youthAGINID.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        phoneNumber.hashCode;
  }
}
