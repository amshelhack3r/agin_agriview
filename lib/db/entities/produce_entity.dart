import 'package:AgriView/models/product.dart';
import 'package:AgriView/models/unit_type.dart';
import 'package:floor/floor.dart';

@Entity(tableName: 'product')
class ProduceEntity extends Product {
  @PrimaryKey(autoGenerate: true)
  int id;
}
