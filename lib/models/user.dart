import 'dart:convert';

class AggregatorRegistration {
  String firstName;
  String lastName;
  String phoneNumber;
  String emailAddress;
  String password;
  int countyID;
  int countryID;
  int status;
  int teamID;
  String dateBirth;
  AggregatorRegistration({
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.emailAddress,
    this.password,
    this.countyID,
    this.countryID,
    this.status,
    this.teamID,
    this.dateBirth,
  });

  AggregatorRegistration copyWith({
    String firstName,
    String lastName,
    String phoneNumber,
    String emailAddress,
    String password,
    int countyID,
    int countryID,
    int status,
    int teamID,
    String dateBirth,
  }) {
    return AggregatorRegistration(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      emailAddress: emailAddress ?? this.emailAddress,
      password: password ?? this.password,
      countyID: countyID ?? this.countyID,
      countryID: countryID ?? this.countryID,
      status: status ?? this.status,
      teamID: teamID ?? this.teamID,
      dateBirth: dateBirth ?? this.dateBirth,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'emailAddress': emailAddress,
      'password': password,
      'countyID': countyID,
      'countryID': countryID,
      'status': status,
      'teamID': teamID,
      'dateBirth': dateBirth,
    };
  }

  factory AggregatorRegistration.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return AggregatorRegistration(
      firstName: map['firstName'],
      lastName: map['lastName'],
      phoneNumber: map['phoneNumber'],
      emailAddress: map['emailAddress'],
      password: map['password'],
      countyID: map['countyID'],
      countryID: map['countryID'],
      status: map['status'],
      teamID: map['teamID'],
      dateBirth: map['dateBirth'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AggregatorRegistration.fromJson(String source) =>
      AggregatorRegistration.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AggregatorRegistration(firstName: $firstName, lastName: $lastName, phoneNumber: $phoneNumber, emailAddress: $emailAddress, password: $password, countyID: $countyID, countryID: $countryID, status: $status, teamID: $teamID, dateBirth: $dateBirth)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is AggregatorRegistration &&
        o.firstName == firstName &&
        o.lastName == lastName &&
        o.phoneNumber == phoneNumber &&
        o.emailAddress == emailAddress &&
        o.password == password &&
        o.countyID == countyID &&
        o.countryID == countryID &&
        o.status == status &&
        o.teamID == teamID &&
        o.dateBirth == dateBirth;
  }

  @override
  int get hashCode {
    return firstName.hashCode ^
        lastName.hashCode ^
        phoneNumber.hashCode ^
        emailAddress.hashCode ^
        password.hashCode ^
        countyID.hashCode ^
        countryID.hashCode ^
        status.hashCode ^
        teamID.hashCode ^
        dateBirth.hashCode;
  }
}
