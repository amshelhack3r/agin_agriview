class FarmerInfo {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String userAginID;

  FarmerInfo(this.firstName, this.lastName, this.phoneNumber, this.userAginID);

  factory FarmerInfo.fromJson(Map<String, dynamic> json) {
    return FarmerInfo(
      json['firstName'],
      json['lastName'],
      json['phoneNumber'],
      json['userAginID'],
    );
  }

  /*accountNumber: 8233308949, accountToken: 251721, addDate: 2020-04-30T02:42:06, createdat: 2019-06-13T04:57:57, emailAddress: isaackntari@yahoo.com, firstName: Judy , lastName: Gathuru, overdraftAmount: 0.0, password: $2b$12$hbGfahs5VBtBy0UGHugazuUkFcV5AH/cvixaed8Dd1/4nQ1nAjEPa, phoneNumber: 254702653259, resetCode: 251721, status: {statusID: 3, statusName: Active}, userAginID: 972880, userID: 963*/
}
