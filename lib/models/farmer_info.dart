import 'dart:convert';

class FarmerInfo {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String userAginID;
  final String createdat;
  FarmerInfo({
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.userAginID,
    this.createdat,
  });

  /*accountNumber: 8233308949, accountToken: 251721, addDate: 2020-04-30T02:42:06, createdat: 2019-06-13T04:57:57, emailAddress: isaackntari@yahoo.com, firstName: Judy , lastName: Gathuru, overdraftAmount: 0.0, password: $2b$12$hbGfahs5VBtBy0UGHugazuUkFcV5AH/cvixaed8Dd1/4nQ1nAjEPa, phoneNumber: 254702653259, resetCode: 251721, status: {statusID: 3, statusName: Active}, userAginID: 972880, userID: 963*/

  FarmerInfo copyWith({
    String firstName,
    String lastName,
    String phoneNumber,
    String userAginID,
    String createdat,
  }) {
    return FarmerInfo(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userAginID: userAginID ?? this.userAginID,
      createdat: createdat ?? this.createdat,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'userAginID': userAginID,
      'createdat': createdat,
    };
  }

  factory FarmerInfo.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return FarmerInfo(
      firstName: map['firstName'],
      lastName: map['lastName'],
      phoneNumber: map['phoneNumber'],
      userAginID: map['userAginID'],
      createdat: map['createdat'],
    );
  }

  String toJson() => json.encode(toMap());

  String get fullname => "$firstName $lastName";
  String get initials =>
      "${firstName.substring(0, 1)}${lastName.substring(0, 1)}".toUpperCase();
  factory FarmerInfo.fromJson(String source) =>
      FarmerInfo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FarmerInfo(firstName: $firstName, lastName: $lastName, phoneNumber: $phoneNumber, userAginID: $userAginID, createdat: $createdat)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is FarmerInfo &&
        o.firstName == firstName &&
        o.lastName == lastName &&
        o.phoneNumber == phoneNumber &&
        o.userAginID == userAginID &&
        o.createdat == createdat;
  }

  @override
  int get hashCode {
    return firstName.hashCode ^
        lastName.hashCode ^
        phoneNumber.hashCode ^
        userAginID.hashCode ^
        createdat.hashCode;
  }
}
