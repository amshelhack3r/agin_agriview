import 'dart:convert';

import 'unit_type.dart';

class Product {
  String fileName;
  String UUID;
  String productName;
  int quantity;
  String name;
  Product({
    this.fileName,
    this.UUID,
    this.productName,
    this.quantity,
    this.name,
  });

  Product copyWith({
    String fileName,
    String UUID,
    String productName,
    int quantity,
    String name,
  }) {
    return Product(
      fileName: fileName ?? this.fileName,
      UUID: UUID ?? this.UUID,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fileName': fileName,
      'UUID': UUID,
      'productName': productName,
      'quantity': quantity,
      'name': name,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Product(
      fileName: map['fileName'],
      UUID: map['UUID'],
      productName: map['productName'],
      quantity: map['quantity'],
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Product(fileName: $fileName, UUID: $UUID, productName: $productName, quantity: $quantity, name: $name)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Product &&
        o.fileName == fileName &&
        o.UUID == UUID &&
        o.productName == productName &&
        o.quantity == quantity &&
        o.name == name;
  }

  @override
  int get hashCode {
    return fileName.hashCode ^
        UUID.hashCode ^
        productName.hashCode ^
        quantity.hashCode ^
        name.hashCode;
  }
}
