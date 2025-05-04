import 'package:equatable/equatable.dart';
import 'package:shopping_list_app/models/shopping_item.dart';

class ShoppingState extends Equatable {
  final List<ShoppingItem> items;

  const ShoppingState({this.items = const []});

  @override
  List<Object> get props => [items];
}