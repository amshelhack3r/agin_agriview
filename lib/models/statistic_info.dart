class StatisticsInfo {
  final int totalFarmers;
  final int totalAcreage;
  final int totalIncome;
  final int totalSales;

  StatisticsInfo(
      this.totalFarmers, this.totalAcreage, this.totalIncome, this.totalSales);

  factory StatisticsInfo.fromJson(Map<String, dynamic> json) {
    return StatisticsInfo(
      json['totalFarmers'],
      json['totalAcreage'],
      json['totalIncome'],
      json['totalSales'],
    );
  }
}
