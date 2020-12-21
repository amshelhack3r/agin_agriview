class ProduceStatus {
  final int id;
  final String statusDecription;

  ProduceStatus({this.id, this.statusDecription});

  factory ProduceStatus.fromJson(Map<String, dynamic> json) {
    return ProduceStatus(
      id: json['id'],
      statusDecription: json['statusDecription'],
    );
  }
}
