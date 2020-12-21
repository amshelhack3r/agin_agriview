class County {
  int countyID;
  String countyName;

  County({this.countyID, this.countyName});

  factory County.fromMap(Map<String, dynamic> map) {
    return County(
      countyID: map['countyID'],
      countyName: map['countyName'],
    );
  }
}
