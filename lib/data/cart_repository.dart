import 'package:shopping_list_app/data/cart_local_data_source.dart';
import 'package:shopping_list_app/data/cart_remote_data_source.dart';
import 'package:shopping_list_app/models/dtos/shopping_item_dto.dart';
import 'package:shopping_list_app/models/dtos/shopping_list_dto.dart';
import 'package:shopping_list_app/models/shopping_item.dart';
import 'package:shopping_list_app/models/shopping_list.dart';

class CartRepository {
  final CartLocalDataSource local;
  final CartRemoteDataSource remote;

  CartRepository({required this.local, required this.remote});  

  Future<List<ShoppingList>> getCarts({bool forceRemote = false}) async {
    if (forceRemote) {
      try {
        final remoteLists = await remote.getCarts();
        await local.clearAll();
        for (var dto in remoteLists) {
          await local.addList(dto.toShoppingList());
        }
      } catch (e) {
        // Handle error, e.g., log it or rethrow
      }
    }

    return local.getAllList();
  }

  ShoppingList? getEditableListById(String id) {
    final index = local.findIndexById(id);
    if (index == -1) return null;
    return local.getAllList()[index];
  }

  Future<void> addCart(ShoppingList cart) async {
    await local.addList(cart);
    await remote.addCart(ShoppingListDto.fromShoppingList(cart));
  }

  Future<void> deleteCartById(String id) async {
    await local.deleteListById(id);
    await remote.deleteCartAsync(id);
  }

  Future<void> updateListById(String id, ShoppingList updatedCart) async {
    await local.updateListById(id, updatedCart);
    await remote.updateCartAsync(id, ShoppingListDto.fromShoppingList(updatedCart));
  }

  Future<List<ShoppingItem>> getItems(String cartId, {bool forceRemote = false}) async {
    if(forceRemote) {
      try {
        final remoteItems = await remote.getCartItemsAsync(cartId);
        final list = local.getEditableListById(cartId);
        if (list != null) {
          final updatedList = ShoppingList(
            id: list.id,
            name: list.name,
            items: remoteItems.map((dto) => dto.toShoppingItem()).toList(),
          );
          
          await local.updateListById(cartId, updatedList);
        }
      } catch (e) {
        // Handle error, e.g., log it or rethrow
      }
    }

    return local.getItems(cartId);    
   }

  Future<void> addItemToList(String listId, ShoppingItem item) async {
    final list = getEditableListById(listId);
    if(list == null) return;
   
    final updatedItems = List<ShoppingItem>.from(list.items)..add(item);
    final updatedList = ShoppingList(
      id: list.id,
      name: list.name,
      items: updatedItems,
    );

    await updateListById(listId, updatedList);

    try {
      await remote.addItemToCart(listId, ShoppingItemDto.fromShoppingItem(item));
    } catch (e) {
      // Handle error, e.g., log it or rethrow
    }
  }

  Future<void> updateItem(String listId, ShoppingItem updatedItem) async {
    final list = getEditableListById(listId);
    if (list == null) return;

    final index = list.items.indexWhere((i) => i.id == updatedItem.id);
    if (index == -1) return;

    list.items[index] = updatedItem;

    await updateListById(listId, list);

    try {
      await remote.updateItemInCart(listId, updatedItem.id, ShoppingItemDto.fromShoppingItem(updatedItem));
    } catch (e) {
      // Handle error, e.g., log it or rethrow
    }
  }

  Future<void> toggleItem(String listId, String itemId) async {
    final list = getEditableListById(listId);
    if (list == null) return;

    final index = list.items.indexWhere((i) => i.id == itemId);
    if (index == -1) return;

    final currentItem = list.items[index];
    final toggledItem = ShoppingItem(
      id: currentItem.id,
      name: currentItem.name,
      category: currentItem.category,
      quantity: currentItem.quantity,
      isBought: !currentItem.isBought);

      list.items[index] = toggledItem;

    await updateListById(listId, list);

    try {
      await remote.updateItemInCart(listId, itemId, ShoppingItemDto.fromShoppingItem(toggledItem));
    } catch (e) {
      // Handle error, e.g., log it or rethrow
    }
  }

  Future<void> deleteItem(String listId, String itemId) async {
    final list = getEditableListById(listId);
    if (list == null) return;

    final updatedItems = list.items.where((i) => i.id != itemId).toList();
    final updatedList = ShoppingList(
      id: list.id,
      name: list.name,
      items: updatedItems,
    );

    await updateListById(listId, updatedList);

    try {
      await remote.deleteItemFromCart(listId, itemId);
    } catch (e) {
      // Handle error, e.g., log it or rethrow
    }
  }
}