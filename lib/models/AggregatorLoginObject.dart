
class AggregatorLoginObject {
  final String youthAGINID;
  final String firstName;
  final String lastName;

  AggregatorLoginObject(this.youthAGINID,this.firstName,this.lastName);

  factory AggregatorLoginObject.fromJson(Map<String, dynamic> json) {
    return AggregatorLoginObject(
      json['youthAGINID'],
      json['firstName'],
      json['lastName'],
    );
  }
}