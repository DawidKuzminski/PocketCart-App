import 'package:json_annotation/json_annotation.dart';
import 'package:shopping_list_app/models/shopping_item.dart';

part 'shopping_item_dto.g.dart';

@JsonSerializable()
class ShoppingItemDto {
  late String id;
  late String name;
  late bool isBought;
  late int quantity;
  late String category;

  ShoppingItemDto({
    required this.id,
    required this.name,
    required this.category,
    this.quantity = 1,
    this.isBought = false,
  });

  factory ShoppingItemDto.fromJson(Map<String, dynamic> json) => _$ShoppingItemDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ShoppingItemDtoToJson(this);

 static ShoppingItemDto fromShoppingItem(ShoppingItem item) {
    return ShoppingItemDto(
      id: item.id,
      name: item.name,
      category: item.category,
      quantity: item.quantity,
      isBought: item.isBought,
    );
  }

  ShoppingItem toShoppingItem() {
    return ShoppingItem(
      id: id,
      name: name,
      category: category,
      quantity: quantity,
      isBought: isBought,
    );
  }
}