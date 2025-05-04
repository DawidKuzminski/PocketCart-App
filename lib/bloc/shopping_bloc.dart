import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_app/bloc/shopping_event.dart';
import 'package:shopping_list_app/bloc/shopping_state.dart';
import 'package:shopping_list_app/models/shopping_item.dart';
import 'package:shopping_list_app/services/storage_service.dart';

class ShoppingBloc extends Bloc<ShoppingEvent, ShoppingState> {
  final StorageService storage;

  ShoppingBloc(this.storage) : super(const ShoppingState()) {
    on<LoadItems>((event, emit) async {
      final items = await storage.loadItems();
      emit(ShoppingState(items: items));
    });

    on<AddItem>((event, emit) async {
      final updated = [...state.items, event.item];
      await storage.saveItems(updated);
      emit(ShoppingState(items: updated));
    });

    on<ToggleItem>((event, emit) async {
      final updated = state.items.map((item) {
        if(item.id == event.id) {
          return ShoppingItem(
            id: item.id, 
            name: item.name,
            isBought: !item.isBought);
        }

        return item;
      }).toList();

      await storage.saveItems(updated);
      emit(ShoppingState(items: updated));
    });

    on<RemoveItem>((event, emit) async {
      final updated = state.items.where((item) => item.id != event.id).toList();

      await storage.saveItems(updated);
      emit(ShoppingState(items: updated));
    });

    on<EditItem>((event, emit) async {
      final updated = state.items.map((item) {
        if(item.id == event.id) {
          return ShoppingItem(id: item.id, name: event.newName, quantity: event.newQuantity);
        }

        return item;
      }).toList();

      await storage.saveItems(updated);
      emit(ShoppingState(items: updated));
    });
  }
}