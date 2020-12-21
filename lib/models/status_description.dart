class StatusDesription {
  final int id;
  final String statusDescription;

  StatusDesription({this.id, this.statusDescription});

  factory StatusDesription.fromJson(Map<String, dynamic> json) {
    return StatusDesription(
      id: json['id'],
      statusDescription: json['statusDescription'],
    );
  }
}
