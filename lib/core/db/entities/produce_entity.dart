import 'package:floor/floor.dart';

import '../../../models/product.dart';

@Entity(tableName: 'product')
class ProduceEntity extends Product {
  @PrimaryKey(autoGenerate: true)
  int id;
}
