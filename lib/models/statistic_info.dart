import 'dart:convert';

class StatisticsInfo {
  final int totalFarmers;
  final int totalAcreage;
  final int totalIncome;
  final int totalSales;
  StatisticsInfo({
    this.totalFarmers,
    this.totalAcreage,
    this.totalIncome,
    this.totalSales,
  });

  StatisticsInfo copyWith({
    int totalFarmers,
    int totalAcreage,
    int totalIncome,
    int totalSales,
  }) {
    return StatisticsInfo(
      totalFarmers: totalFarmers ?? this.totalFarmers,
      totalAcreage: totalAcreage ?? this.totalAcreage,
      totalIncome: totalIncome ?? this.totalIncome,
      totalSales: totalSales ?? this.totalSales,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalFarmers': totalFarmers,
      'totalAcreage': totalAcreage,
      'totalIncome': totalIncome,
      'totalSales': totalSales,
    };
  }

  factory StatisticsInfo.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return StatisticsInfo(
      totalFarmers: map['totalFarmers'],
      totalAcreage: map['totalAcreage'],
      totalIncome: map['totalIncome'],
      totalSales: map['totalSales'],
    );
  }

  String toJson() => json.encode(toMap());

  factory StatisticsInfo.fromJson(String source) =>
      StatisticsInfo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'StatisticsInfo(totalFarmers: $totalFarmers, totalAcreage: $totalAcreage, totalIncome: $totalIncome, totalSales: $totalSales)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is StatisticsInfo &&
        o.totalFarmers == totalFarmers &&
        o.totalAcreage == totalAcreage &&
        o.totalIncome == totalIncome &&
        o.totalSales == totalSales;
  }

  @override
  int get hashCode {
    return totalFarmers.hashCode ^
        totalAcreage.hashCode ^
        totalIncome.hashCode ^
        totalSales.hashCode;
  }
}
