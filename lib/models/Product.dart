class Product {
  final int productID;
  final String productName;
  final String fileName;
  final String UUID;

  Product(this.productID, this.productName, this.fileName, this.UUID);

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      json['productID'],
      json.containsKey("productName") ? json['productName'] : json['name'],
      json['fileName'],
      json['UUID'],
    );
  }
}