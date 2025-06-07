import 'package:hive/hive.dart';

part 'shopping_item.g.dart';

@HiveType(typeId: 1)
class ShoppingItem extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late bool isBought;

  @HiveField(3)
  late int quantity;

  @HiveField(4)
  late String category;

  ShoppingItem({
    required this.id,
    required this.name,
    required this.category,
    this.quantity = 1,
    this.isBought = false,
  });
}