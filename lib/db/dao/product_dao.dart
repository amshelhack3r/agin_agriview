import "package:floor/floor.dart";

import '../entities/produce_entity.dart';
import 'abstract_dao.dart';

@dao
abstract class ProductDao extends AbstractDao<ProduceEntity> {
  @Query("SELECT * FROM product")
  Future<List<ProduceEntity>> getProducts();
}
