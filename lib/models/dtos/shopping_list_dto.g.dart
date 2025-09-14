// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShoppingListDto _$ShoppingListDtoFromJson(Map<String, dynamic> json) =>
    ShoppingListDto(
      id: json['id'] as String,
      name: json['name'] as String,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => ShoppingItemDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ShoppingListDtoToJson(ShoppingListDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'items': instance.items,
    };
