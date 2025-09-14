import 'package:json_annotation/json_annotation.dart';
import 'package:shopping_list_app/models/dtos/shopping_item_dto.dart';
import 'package:shopping_list_app/models/shopping_list.dart';

part 'shopping_list_dto.g.dart';

@JsonSerializable()
class ShoppingListDto {
  late String id;
  late String name;
  late List<ShoppingItemDto> items;

  ShoppingListDto({
    required this.id,
    required this.name,
    this.items = const [],
  });

  factory ShoppingListDto.fromJson(Map<String, dynamic> json) => _$ShoppingListDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ShoppingListDtoToJson(this);

  static fromShoppingList(ShoppingList cart) {
    return ShoppingListDto(
      id: cart.id,
      name: cart.name,
      items: cart.items.map((item) => ShoppingItemDto.fromShoppingItem(item)).toList(),
    );
  }

  ShoppingList toShoppingList() {
    return ShoppingList(
      id: id,
      name: name,
      items: items.map((itemDto) => itemDto.toShoppingItem()).toList(),
    );
  }
}