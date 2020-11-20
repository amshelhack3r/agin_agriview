class FarmerProduceProductInfo {
  final int productID;


  FarmerProduceProductInfo(this.productID);

  factory FarmerProduceProductInfo.fromJson(Map<String, dynamic> json) {
    return FarmerProduceProductInfo(
      json['productID'],

    );
  }

}