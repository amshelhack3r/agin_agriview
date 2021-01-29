import 'dart:convert';

class Product {
  String fileName;
  String uuid;
  String productName;
  int quantity;
  Product({
    this.fileName,
    this.uuid,
    this.productName,
    this.quantity,
  });

  Product copyWith({
    String fileName,
    String uuid,
    String productName,
    int quantity,
  }) {
    return Product(
      fileName: fileName ?? this.fileName,
      uuid: uuid ?? this.uuid,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fileName': fileName,
      'uuid': uuid,
      'productName': productName,
      'quantity': quantity,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Product(
      fileName: map['fileName'],
      uuid: map['UUID'],
      productName: map['productName'],
      quantity: map['quantity'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Product(fileName: $fileName, uuid: $uuid, productName: $productName, quantity: $quantity)';
  }

  String get initials => productName.substring(1, 2);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Product &&
        o.fileName == fileName &&
        o.uuid == uuid &&
        o.productName == productName &&
        o.quantity == quantity;
  }

  @override
  int get hashCode {
    return fileName.hashCode ^
        uuid.hashCode ^
        productName.hashCode ^
        quantity.hashCode;
  }
}
