
import 'package:AgriView/models/FarmerProduceProduct.dart';
import 'package:AgriView/models/Product.dart';

class FarmerProduceInfo {
  final Product productUuid;

  FarmerProduceInfo(this.productUuid);

  factory FarmerProduceInfo.fromJson(Map<String, dynamic> json) {
    return FarmerProduceInfo(
      Product.fromJson(json['productUuid']),
    );
  }

}