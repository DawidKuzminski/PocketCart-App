import 'package:shopping_list_app/models/shopping_item.dart';
import 'package:shopping_list_app/models/shopping_list.dart';

abstract class ShoppingEvent {}

class LoadLists extends ShoppingEvent {}

class AddList extends ShoppingEvent {
  final ShoppingList list;
  AddList(this.list);
}

class DeleteList extends ShoppingEvent {
  final String id;
  DeleteList(this.id);
}

class UpdateList extends ShoppingEvent {
  final String id;
  final String newName;
  UpdateList(this.id, this.newName);
}

class AddItemToList extends ShoppingEvent {
  String listId;
  final ShoppingItem item;
  AddItemToList(this.listId, this.item);
}

class ToggleItemInList extends ShoppingEvent {
  final String listId;
  final String itemId;
  ToggleItemInList(this.listId, this.itemId);
}

class RemoveItemFromList extends ShoppingEvent {
  final String listId;
  final String itemId;

  RemoveItemFromList(this.listId, this.itemId);
}

class UpdateItemInList extends ShoppingEvent {
  final String listId;
  final ShoppingItem item;

  UpdateItemInList(this.listId, this.item);
}