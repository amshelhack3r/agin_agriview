class CultivationMode {
  final int id;
  final String modeDescription;

  CultivationMode({this.id, this.modeDescription});

  factory CultivationMode.fromJson(Map<String, dynamic> json) {
    return CultivationMode(
      id: json['id'],
      modeDescription: json['modeDescription'],
    );
  }
}
