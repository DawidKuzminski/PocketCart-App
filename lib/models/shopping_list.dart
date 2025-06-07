import 'package:hive/hive.dart';
import 'package:shopping_list_app/models/shopping_item.dart';

part 'shopping_list.g.dart';

@HiveType(typeId: 0)
class ShoppingList extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late List<ShoppingItem> items;

  ShoppingList({
    required this.id,
    required this.name,
    this.items = const [],
  });
}