class County {

  int countyID;
  String countyName;

  County({this.countyID, this.countyName});

  factory County.fromJson(Map<String, dynamic> json) {
    return County(
      countyID : json['countyID'],
      countyName : json['countyName'],
    );
  }






}