import 'package:shopping_list_app/models/shopping_item.dart';

abstract class ShoppingEvent {}

class LoadItems extends ShoppingEvent {}

class AddItem extends ShoppingEvent {
  final ShoppingItem item;
  AddItem(this.item);
}

class ToggleItem extends ShoppingEvent {
  final String id;
  ToggleItem(this.id);
}

class RemoveItem extends ShoppingEvent {
  final String id;
  RemoveItem(this.id);
}

class EditItem extends ShoppingEvent {
  final String id;
  final String newName;
  final int newQuantity;
  final String newCategory;
  EditItem(this.id, this.newName, this.newQuantity, this.newCategory);
}