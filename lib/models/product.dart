import 'dart:convert';

class Product {
  String image;
  String name;
  Product({
    this.image,
    this.name,
  });

  Product copyWith({
    String image,
    String name,
  }) {
    return Product(
      image: image ?? this.image,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'name': name,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Product(
      image: map['image'],
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));

  @override
  String toString() => 'Product(image: $image, name: $name)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Product && o.image == image && o.name == name;
  }

  @override
  int get hashCode => image.hashCode ^ name.hashCode;
}
