import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_app/bloc/shoppingList/shopping_list_event.dart';
import 'package:shopping_list_app/bloc/shoppingList/shopping_list_state.dart';
import 'package:shopping_list_app/models/shopping_list.dart';
import 'package:shopping_list_app/services/shopping_list_repository.dart';

class ShoppingListBloc extends Bloc<ShoppingEvent, ShoppingListState> {
  final ShoppingListService storage;

  ShoppingListBloc(this.storage) : super (ShoppingListState(lists: [])) {
    on<LoadLists>((event, emit) {
      final lists = storage.getAllList();
      emit(ShoppingListState(lists: lists));
    });

    on<AddList>((event, emit) async {
      await storage.addList(event.list);
      emit(ShoppingListState(lists: storage.getAllList()));
    });

    on<DeleteList>((event, emit) async {
      await storage.deleteListById(event.id);
      emit(ShoppingListState(lists: storage.getAllList()));
    });

    on<UpdateList>((event, emit) async {
      final current = storage.getEditableListById(event.id);
      if (current == null) return;

      final updated = ShoppingList(
        id: current.id,
        name: event.newName,
        items: current.items,
      );

      await storage.updateListById(event.id, updated);
      emit(ShoppingListState(lists: storage.getAllList()));
    });

    on<AddItemToList>((event, emit) async {
      await storage.addItemToList(event.listId, event.item);
      emit(ShoppingListState(lists: storage.getAllList()));
    });

    on<UpdateItemInList>((event, emit) async {
      final currentList = storage.getEditableListById(event.listId);
      if(currentList == null) return;

      await storage.updateItem(event.listId, event.item);
      emit(ShoppingListState(lists: storage.getAllList()));
    });

    on<RemoveItemFromList>((event, emit) async {
      await storage.deleteItem(event.listId, event.itemId);
      emit(ShoppingListState(lists: storage.getAllList()));
    });

    on<ToggleItemInList>((event, emit) async {
      await storage.toggleItem(event.listId, event.itemId);
      emit(ShoppingListState(lists: storage.getAllList()));
    });
  }
}