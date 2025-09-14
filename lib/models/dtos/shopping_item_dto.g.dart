// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShoppingItemDto _$ShoppingItemDtoFromJson(Map<String, dynamic> json) =>
    ShoppingItemDto(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      isBought: json['isBought'] as bool? ?? false,
    );

Map<String, dynamic> _$ShoppingItemDtoToJson(ShoppingItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isBought': instance.isBought,
      'quantity': instance.quantity,
      'category': instance.category,
    };
