class Album {
  final int countyID;
  final String countyName;

  Album({this.countyID, this.countyName});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      countyID: json['countyID'],
      countyName: json['countyName'],
    );
  }
}
