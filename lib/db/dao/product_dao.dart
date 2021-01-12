import "package:floor/floor.dart";

import '../entities/produce_entity.dart';

@dao
abstract class ProductDao {
  @Query("SELECT * FROM product")
  Future<List<ProduceEntity>> getProducts();

  @insert
  Future<void> insertProduct(ProduceEntity product);
}
